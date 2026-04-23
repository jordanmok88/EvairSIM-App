import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../push/push_notification_service.dart';

/// JS↔Dart bridge exposed to the H5 site.
///
/// After [register] is called on an [InAppWebViewController], H5 can call:
///
/// ```js
/// await window.evair.share({ title: 'Evair', url: 'https://…' });
/// await window.evair.openExternal('https://apps.apple.com/…');
/// await window.evair.copyToClipboard('ABC123');
/// const info = await window.evair.getAppInfo(); // { platform, version }
/// await window.evair.haptic('light');
/// ```
///
/// Phase 2 bridge additions (shipped now):
///   * registerForPush()      — asks iOS / Android for notification
///                              permission, returns the FCM / APNs
///                              device token so H5 can POST it to
///                              Laravel's /push/register endpoint.
///
/// Still planned:
///   * installEsim(lpa)       — native CTCellularPlanProvisioning
///   * scanQr()               — mobile_scanner
///   * biometricAuth()        — local_auth
///
/// Push messages received by the device call BACK into H5 via the
/// following handlers that H5 can register (all take a JSON payload):
///   * window.evair.onPushTokenReady({ token })
///   * window.evair.onPushReceived({ ...data })   — foreground arrival
///   * window.evair.onPushOpened({ ...data })     — user tapped banner
///
/// See docs/native-bridge-api.md for the contract shipped to H5 devs.
class NativeBridge {
  /// Wire all handlers on [controller] and inject the `window.evair` shim
  /// so H5 has a single entry point regardless of platform.
  ///
  /// Skipped on Flutter Web — flutter_inappwebview's web backend lacks
  /// `addJavaScriptHandler` / `addUserScript`. When running in a regular
  /// browser, H5 falls back to native Web APIs (navigator.share,
  /// window.open, navigator.clipboard) per
  /// docs/native-bridge-api.md.
  static void register(InAppWebViewController controller) {
    if (kIsWeb) return;

    _add(controller, 'share', _share);
    _add(controller, 'openExternal', _openExternal);
    _add(controller, 'copyToClipboard', _copyToClipboard);
    _add(controller, 'getAppInfo', _getAppInfo);
    _add(controller, 'haptic', _haptic);
    _add(controller, 'registerForPush', _registerForPush);

    // Hand the live controller to the push service so it can push
    // token-ready / push-received events BACK into H5 as JS callbacks.
    PushNotificationService.instance.attachWebView(controller);

    // Inject a thin JS shim so H5 calls read naturally. The raw
    // `window.flutter_inappwebview.callHandler` returns a Promise already,
    // so we just wrap each handler in a named function.
    controller.addUserScript(
      userScript: UserScript(
        source: _kBridgeShim,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      ),
    );
  }

  /// Open a URL in the system browser. Used both by H5 via the bridge
  /// and by [WebViewShellPage] when it intercepts an external link.
  static Future<void> openExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ---------------------------------------------------------------------------
  // Handlers — each returns a JSON-serialisable value (or null).
  // ---------------------------------------------------------------------------

  static Future<dynamic> _share(List<dynamic> args) async {
    final payload = _firstMap(args);
    final title = (payload['title'] as String?) ?? '';
    final text = (payload['text'] as String?) ?? '';
    final url = (payload['url'] as String?) ?? '';
    final body = [text, url].where((s) => s.isNotEmpty).join('\n');
    if (body.isEmpty) return {'ok': false, 'reason': 'empty'};
    // share_plus 10.x API: top-level `Share.share(text, subject:)`.
    await Share.share(body, subject: title.isNotEmpty ? title : null);
    return {'ok': true};
  }

  static Future<dynamic> _openExternal(List<dynamic> args) async {
    final url = args.isNotEmpty ? args.first?.toString() ?? '' : '';
    if (url.isEmpty) return {'ok': false, 'reason': 'empty'};
    await openExternal(url);
    return {'ok': true};
  }

  static Future<dynamic> _copyToClipboard(List<dynamic> args) async {
    final text = args.isNotEmpty ? args.first?.toString() ?? '' : '';
    await Clipboard.setData(ClipboardData(text: text));
    return {'ok': true};
  }

  static Future<dynamic> _getAppInfo(List<dynamic> args) async {
    String platform;
    if (kIsWeb) {
      platform = 'web';
    } else if (Platform.isIOS) {
      platform = 'ios';
    } else if (Platform.isAndroid) {
      platform = 'android';
    } else {
      platform = 'unknown';
    }
    return {
      'platform': platform,
      // Keep in sync with pubspec version until we wire package_info_plus.
      'version': '1.0.0',
      'buildNumber': '1',
    };
  }

  /// Ask the OS for notification permission and return the device push
  /// token. H5 should call this right after a successful login and POST
  /// the resulting token to `/api/v1/h5/push/register`.
  ///
  /// Returns `{ ok: true, token: '<fcm_token>' }` on success,
  /// `{ ok: false, reason: 'denied' }` if the user refused, or
  /// `{ ok: false, reason: 'unsupported' }` on platforms without push
  /// (Flutter Web).
  static Future<dynamic> _registerForPush(List<dynamic> args) async {
    if (kIsWeb) {
      return {'ok': false, 'reason': 'unsupported'};
    }
    final token = await PushNotificationService.instance
        .requestPermissionAndGetToken();
    if (token == null) {
      return {'ok': false, 'reason': 'denied'};
    }
    return {'ok': true, 'token': token};
  }

  static Future<dynamic> _haptic(List<dynamic> args) async {
    final type = (args.isNotEmpty ? args.first?.toString() : 'light') ?? 'light';
    switch (type) {
      case 'medium':
        await HapticFeedback.mediumImpact();
      case 'heavy':
        await HapticFeedback.heavyImpact();
      case 'selection':
        await HapticFeedback.selectionClick();
      case 'light':
      default:
        await HapticFeedback.lightImpact();
    }
    return {'ok': true};
  }

  // ---------------------------------------------------------------------------
  // Internal helpers.
  // ---------------------------------------------------------------------------

  static void _add(
    InAppWebViewController controller,
    String name,
    Future<dynamic> Function(List<dynamic>) handler,
  ) {
    controller.addJavaScriptHandler(
      handlerName: '__evair_$name',
      callback: (args) async {
        try {
          return await handler(args);
        } catch (e, st) {
          debugPrint('NativeBridge[$name] error: $e\n$st');
          return {'ok': false, 'error': e.toString()};
        }
      },
    );
  }

  static Map<String, dynamic> _firstMap(List<dynamic> args) {
    if (args.isEmpty) return const {};
    final v = args.first;
    if (v is Map) {
      return v.map((k, value) => MapEntry(k.toString(), value));
    }
    if (v is String) {
      try {
        final decoded = jsonDecode(v);
        if (decoded is Map) {
          return decoded.map((k, value) => MapEntry(k.toString(), value));
        }
      } catch (_) {}
    }
    return const {};
  }
}

/// JS shim injected into every H5 page so `window.evair.foo(args)` becomes
/// a normal async function call on the H5 side. Kept in one place so the
/// surface is easy to audit / document.
const String _kBridgeShim = r'''
(function () {
  if (window.evair) return;
  var call = function (name) {
    return function () {
      var args = Array.prototype.slice.call(arguments);
      if (!window.flutter_inappwebview || !window.flutter_inappwebview.callHandler) {
        return Promise.resolve({ ok: false, reason: 'not_in_app' });
      }
      return window.flutter_inappwebview.callHandler.apply(
        window.flutter_inappwebview,
        ['__evair_' + name].concat(args)
      );
    };
  };
  window.evair = {
    isNative: true,
    share:           call('share'),
    openExternal:    call('openExternal'),
    copyToClipboard: call('copyToClipboard'),
    getAppInfo:      call('getAppInfo'),
    haptic:          call('haptic'),
    registerForPush: call('registerForPush'),
    // Inbound hooks (Dart → JS). H5 may overwrite any of these to receive
    // events. The default is a no-op so unhandled events don't throw.
    onPushTokenReady: function () {},
    onPushReceived:   function () {},
    onPushOpened:     function () {},
  };
})();
''';
