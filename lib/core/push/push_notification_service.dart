import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Thin wrapper around Firebase Messaging + local notifications.
///
/// Responsibilities:
///   * Bootstrap the Firebase SDK once per app launch.
///   * Request OS notification permission (iOS explicit prompt; Android
///     13+ falls under POST_NOTIFICATIONS runtime permission).
///   * Resolve a device push token and forward it to H5 via the bridge
///     so H5 can POST it to Laravel's /push/register endpoint.
///   * Listen for token rotations and re-notify H5 so the backend row
///     stays valid.
///   * When a remote message arrives:
///       - foreground: render a banner with flutter_local_notifications
///         (FCM doesn't auto-show foreground pushes) AND forward the
///         payload to H5 via `window.evair.onPushReceived` for in-app
///         behaviour (toast, list refresh, etc.).
///       - background / terminated: the OS draws the notification. On
///         tap, navigate the WebView to the `route` inside `data`.
///
/// Kept as a singleton so it can be called before the WebView exists
/// (from main.dart) and then attached later.
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  /// Android channel for time-critical order / payment / eSIM lifecycle
  /// alerts. High importance → OS plays the default sound and shows a
  /// heads-up banner.
  static const _transactionalChannel = AndroidNotificationChannel(
    'evair_transactional',
    'Order & eSIM alerts',
    description:
        'Payment confirmations, eSIM delivery, data-usage warnings, and '
        'other time-critical updates about your orders. These cannot be '
        'disabled without turning off all notifications in system settings.',
    importance: Importance.high,
  );

  /// Low-importance channel for promos / re-engagement. Users can mute
  /// this from system settings on Android; we also honour the server-side
  /// `marketing_enabled` flag before ever sending to this channel.
  static const _marketingChannel = AndroidNotificationChannel(
    'evair_marketing',
    'News & promotions',
    description: 'New plans, travel tips, and special offers. Optional.',
    importance: Importance.low,
  );

  final _fln = FlutterLocalNotificationsPlugin();
  InAppWebViewController? _webViewController;
  String? _lastToken;
  bool _initialized = false;

  /// Call this from `main()` BEFORE runApp. It:
  ///   1. Boots Firebase.
  ///   2. Creates the Android notification channels.
  ///   3. Registers the top-level background handler.
  ///
  /// We deliberately do NOT request permissions here — we want to wait
  /// until the user is logged in so we don't get the "spammy app asks
  /// for notifications before doing anything useful" iOS prompt on
  /// first launch.
  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    _initialized = true;

    await Firebase.initializeApp();

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(
        // Defer OS permission prompt to requestPermissionAndGetToken().
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _fln.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    if (Platform.isAndroid) {
      final androidImpl = _fln.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.createNotificationChannel(_transactionalChannel);
      await androidImpl?.createNotificationChannel(_marketingChannel);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessagingHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedAppMessage);
    FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);
  }

  /// Give the service a handle to the live WebView controller so it can
  /// deliver token updates + push payloads to H5 via `window.evair.*`.
  void attachWebView(InAppWebViewController controller) {
    _webViewController = controller;
    // If a token was resolved before the WebView finished loading,
    // replay it now.
    final token = _lastToken;
    if (token != null) {
      _notifyH5TokenReady(token);
    }
  }

  /// Ask the OS for notification permission AND return the current
  /// device push token. Called from H5 via the bridge method
  /// `window.evair.registerForPush()` after a successful login.
  ///
  /// Returns null if the user declined permission or if the platform
  /// doesn't support push (Flutter Web).
  Future<String?> requestPermissionAndGetToken() async {
    if (kIsWeb) return null;

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;
    if (!granted) return null;

    // iOS: FCM token isn't resolvable until APNs has issued one.
    if (Platform.isIOS) {
      final apns = await FirebaseMessaging.instance.getAPNSToken();
      if (apns == null) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _lastToken = token;
      _notifyH5TokenReady(token);
    }
    return token;
  }

  Future<void> _onTokenRefresh(String token) async {
    _lastToken = token;
    _notifyH5TokenReady(token);
  }

  /// Show a local banner while the app is in the foreground (FCM does
  /// NOT do this automatically — by default foreground pushes are
  /// delivered silently to `onMessage` and never drawn).
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final category = message.data['category'] ?? 'transactional';
    final channel = category == 'marketing'
        ? _marketingChannel
        : _transactionalChannel;

    if (notification != null) {
      await _fln.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: channel.importance,
            icon: '@mipmap/launcher_icon',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }

    await _forwardToH5('onPushReceived', Map<String, dynamic>.from(message.data));
  }

  /// Tap handler when the user opens the app via a notification in
  /// background / terminated state.
  Future<void> _handleOpenedAppMessage(RemoteMessage message) async {
    final data = Map<String, dynamic>.from(message.data);
    await _forwardToH5('onPushOpened', data);
    final route = data['route'];
    if (route is String && route.isNotEmpty) {
      await _navigateWebView(route);
    }
  }

  /// Tap handler for foreground banners drawn by flutter_local_notifications.
  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    Map<String, dynamic> data = {};
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        data = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      return;
    }
    unawaited(_forwardToH5('onPushOpened', data));
    final route = data['route'];
    if (route is String && route.isNotEmpty) {
      unawaited(_navigateWebView(route));
    }
  }

  void _notifyH5TokenReady(String token) {
    unawaited(_forwardToH5('onPushTokenReady', {'token': token}));
  }

  /// Best-effort JS bridge delivery. If the WebView isn't attached yet,
  /// we no-op — `_lastToken` will be replayed when `attachWebView` runs.
  Future<void> _forwardToH5(String eventName, Map<String, dynamic> data) async {
    final controller = _webViewController;
    if (controller == null) return;
    final jsonArg = jsonEncode(data);
    // Guard with `typeof` so we don't blow up in the console if H5
    // hasn't registered this handler yet (older cached builds).
    final js = '''
      (function() {
        try {
          if (window.evair && typeof window.evair.$eventName === 'function') {
            window.evair.$eventName($jsonArg);
          }
        } catch (e) { /* swallow */ }
      })();
    ''';
    try {
      await controller.evaluateJavascript(source: js);
    } catch (_) {
      // WebView mid-reload or disposed — ignore.
    }
  }

  Future<void> _navigateWebView(String route) async {
    final controller = _webViewController;
    if (controller == null) return;
    final uri = Uri.tryParse(route);
    // Full URL wins; otherwise treat as a path on the current origin.
    if (uri != null && uri.hasScheme) {
      await controller.loadUrl(urlRequest: URLRequest(url: WebUri(route)));
      return;
    }
    final current = await controller.getUrl();
    if (current == null) return;
    final target = current.replace(
      path: route.startsWith('/') ? route : '/$route',
    );
    await controller.loadUrl(urlRequest: URLRequest(url: target));
  }
}

/// Top-level background handler. Must be annotated with `vm:entry-point`
/// so the Flutter engine can find it when the isolate is cold-started
/// by the OS for a background message.
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessagingHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint(
    '[push] background message: id=${message.messageId} data=${message.data}',
  );
}
