import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/bridge/native_bridge.dart';
import '../../../core/constants/app_constants.dart';

/// The one and only page of the native shell.
///
/// Hosts the H5 site full-screen inside an [InAppWebView]. Users perceive
/// a native app (splash, app icon, push, system share) while every screen
/// below is actually served by H5 — so any change shipped to H5 shows up
/// in the APP on next page reload.
///
/// Responsibilities:
///   * Load [AppConstants.h5Url] full-screen, no browser chrome.
///   * Show a splash overlay until the first paint completes so users
///     never see a white flash while the site boots.
///   * Wire the `window.evair.*` JS bridge so H5 can call native features
///     (share, external links, clipboard, app info, haptics).
///   * Handle Android hardware-back by stepping through WebView history
///     first, then exiting the app at the root.
///   * Offer pull-to-refresh for flaky networks.
///   * Fall back to an offline error screen with a Retry button.
class WebViewShellPage extends StatefulWidget {
  const WebViewShellPage({super.key});

  @override
  State<WebViewShellPage> createState() => _WebViewShellPageState();
}

class _WebViewShellPageState extends State<WebViewShellPage> {
  InAppWebViewController? _controller;
  PullToRefreshController? _pullToRefresh;

  // `_isLoading` gates the splash overlay; `_hasError` gates the offline
  // retry screen. Kept as separate bits so we can show an error *after*
  // a successful first paint (e.g. navigating to a page that fails to
  // load) without re-showing the splash.
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  // Branded splash must stay visible for at least this long on the very
  // first launch so customers actually see the logo, even on fast
  // connections where the WebView finishes loading in <500ms.
  static const Duration _minSplashDuration = Duration(milliseconds: 2000);
  DateTime? _splashStart;
  bool _firstLoadComplete = false;

  @override
  void initState() {
    super.initState();
    _splashStart = DateTime.now();
    // Pull-to-refresh is iOS bouncy / Android Material. `onRefresh` just
    // triggers a reload of the current URL — H5 handles its own data
    // freshness from there. The Flutter-Web backend of
    // flutter_inappwebview does NOT implement pull-to-refresh, so we
    // skip it there to avoid `UnimplementedError` at runtime.
    if (!kIsWeb) {
      _pullToRefresh = PullToRefreshController(
        settings: PullToRefreshSettings(color: const Color(0xFFFF6600)),
        onRefresh: () async {
          if (defaultTargetPlatform == TargetPlatform.android) {
            await _controller?.reload();
          } else {
            final url = await _controller?.getUrl();
            if (url != null) {
              await _controller?.loadUrl(urlRequest: URLRequest(url: url));
            }
          }
        },
      );
    }

    // On Flutter Web there is no real WebView — `flutter_inappwebview`
    // would wrap H5 in a cross-origin iframe whose load events don't
    // fire reliably, and which doesn't represent the real iOS/Android
    // experience anyway. Instead, just redirect this tab to the H5
    // site so the "APP preview" at :8080 shows exactly what the native
    // shell will render inside its WebView at runtime. The real native
    // shell code path (the `_buildWebView` below) is only exercised
    // on iOS and Android.
    if (kIsWeb) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        final uri = Uri.tryParse(AppConstants.h5Url);
        if (uri == null) return;
        await launchUrl(uri, webOnlyWindowName: '_self');
      });
    }
  }


  Future<bool> _handleBackPress() async {
    final controller = _controller;
    if (controller == null) return true;
    if (await controller.canGoBack()) {
      await controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Flutter Web: render only the splash while the post-frame callback
    // triggered in initState redirects the tab to H5. The real WebView
    // code path below is mobile-only.
    if (kIsWeb) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: _SplashOverlay(),
      );
    }

    // Follow the OS light/dark setting so the native shell chrome (status
    // bar icons, Scaffold background behind the WebView during load) never
    // clashes with the H5 theme. H5 itself listens to
    // `prefers-color-scheme` via Tailwind v4's custom `dark:` variant — the
    // two stay in sync automatically without needing a bridge message.
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF0B1120) : const Color(0xFFFFFFFF);
    // SystemUiOverlayStyle's `statusBarIconBrightness` is the *contrast* of
    // the icons against the status bar background, i.e. Brightness.light =
    // white icons (for a dark phone background) and Brightness.dark = black
    // icons (for a light phone background). Naming is historically
    // confusing; we compute it explicitly.
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light, // iOS
      statusBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark, // Android
      systemNavigationBarColor: bgColor,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final shouldPop = await _handleBackPress();
          if (shouldPop && mounted) {
            // No more history inside WebView — let the system pop (which on
            // the root route exits the app on Android).
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                _buildWebView(isDark: isDark),
                if (_isLoading) const _SplashOverlay(),
                if (_hasError)
                  _ErrorOverlay(
                    isDark: isDark,
                    message: _errorMessage,
                    onRetry: () {
                      setState(() {
                        _hasError = false;
                        _errorMessage = null;
                        _isLoading = true;
                      });
                      _controller?.loadUrl(
                        urlRequest: URLRequest(url: WebUri(AppConstants.h5Url)),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebView({required bool isDark}) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(AppConstants.h5Url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        allowsBackForwardNavigationGestures: true,
        allowsInlineMediaPlayback: true,
        useOnDownloadStart: true,
        // Let the WebView persist cookies/localStorage across app launches
        // so users stay logged in to H5.
        clearCache: false,
        // Default Android WebView UA is very old and trips CSRF / bot
        // heuristics. Spoofing a modern Chrome UA keeps H5 behaviour
        // identical to the real browser.
        userAgent: _userAgent(),
        // Make the WebView's own background transparent so the Scaffold's
        // themed bgColor shows through during the brief moment between
        // `onLoadStart` and the first paint of the new document. Without
        // this, the WebView flashes a hard-coded white on every navigation
        // which looks awful on a dark device.
        transparentBackground: true,
        // Leave most security defaults alone — H5 is trusted and we load
        // a known origin only.
      ),
      pullToRefreshController: _pullToRefresh,
      onWebViewCreated: (controller) {
        _controller = controller;
        NativeBridge.register(controller);
      },
      onLoadStart: (_, url) {
        if (!mounted) return;
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
      },
      onLoadStop: (_, url) async {
        _pullToRefresh?.endRefreshing();
        if (!mounted) return;
        // On the very first load, keep the splash visible for at least
        // [_minSplashDuration] so the Evair logo is actually perceivable
        // even on fast networks. Subsequent in-app navigations skip the
        // delay and hide the spinner immediately.
        if (!_firstLoadComplete) {
          _firstLoadComplete = true;
          final elapsed =
              DateTime.now().difference(_splashStart ?? DateTime.now());
          final remaining = _minSplashDuration - elapsed;
          if (remaining > Duration.zero) {
            await Future.delayed(remaining);
          }
          if (!mounted) return;
        }
        setState(() => _isLoading = false);
      },
      onReceivedError: (_, request, error) {
        _pullToRefresh?.endRefreshing();
        // Only show the offline screen for the main frame — sub-resource
        // failures (ads, analytics) shouldn't blank out the app. The
        // `isForMainFrame` flag is nullable; a null is treated as "main
        // frame" so we never silently swallow an error we can't classify.
        if (request.isForMainFrame == false) return;
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = error.description;
        });
      },
      shouldOverrideUrlLoading: (controller, action) async {
        final uri = action.request.url;
        if (uri == null) return NavigationActionPolicy.ALLOW;

        // iOS WKWebView fires shouldOverrideUrlLoading for *every* frame,
        // including iframes. Third-party SDKs H5 embeds (Stripe.js, 3-D
        // Secure, analytics pixels, reCAPTCHA, social embeds) all load
        // in iframes on domains other than H5's — they MUST stay inside
        // the WebView, otherwise every checkout bounces the user out
        // to Safari on js.stripe.com.
        if (action.isForMainFrame == false) {
          return NavigationActionPolicy.ALLOW;
        }

        // Non-http(s) schemes are always system-handled (mailto:, tel:,
        // sms:, whatsapp:, itms-apps:, etc.).
        final scheme = uri.scheme.toLowerCase();
        if (scheme != 'http' && scheme != 'https') {
          await NativeBridge.openExternal(uri.toString());
          return NavigationActionPolicy.CANCEL;
        }

        // Same-origin navigations or relative paths: stay internal.
        if (_shouldHandleInternally(uri)) {
          return NavigationActionPolicy.ALLOW;
        }

        // Payment / auth redirects: checkout flows legitimately bounce
        // through third-party hosts (Stripe Checkout, PayPal, bank 3-DS
        // pages, Apple / Google Pay return URLs) before returning to
        // H5. Kicking these to Safari would break payment entirely, so
        // keep them in-WebView.
        if (_isTrustedRedirectHost(uri.host)) {
          return NavigationActionPolicy.ALLOW;
        }

        // Everything else (external marketing links, arbitrary outbound
        // URLs from the H5) opens in the system browser.
        await NativeBridge.openExternal(uri.toString());
        return NavigationActionPolicy.CANCEL;
      },
    );
  }

  bool _shouldHandleInternally(WebUri uri) {
    final target = Uri.tryParse(AppConstants.h5Url);
    if (target == null) return true;
    // Same host OR a relative navigation on the current page.
    if (uri.host.isEmpty) return true;
    return uri.host == target.host;
  }

  /// Hosts the H5 is known to redirect through for payments or auth.
  /// Matches the exact host or any subdomain of an entry.
  bool _isTrustedRedirectHost(String host) {
    if (host.isEmpty) return false;
    final h = host.toLowerCase();
    const allowList = <String>[
      // Stripe
      'stripe.com',
      'stripe.network',
      // PayPal
      'paypal.com',
      'paypalobjects.com',
      // Apple Pay
      'apple.com',
      // Google Pay
      'google.com',
      'googleapis.com',
      'gstatic.com',
      // reCAPTCHA (checkout anti-fraud)
      'recaptcha.net',
      // Alipay / WeChat Pay (common in CN market)
      'alipay.com',
      'alipayobjects.com',
      'tenpay.com',
      'wechat.com',
      'wechatpay.com',
      'weixin.qq.com',
    ];
    return allowList.any((d) => h == d || h.endsWith('.$d'));
  }

  String _userAgent() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 '
          'Mobile/15E148 Safari/604.1 EvairSIM/1.0';
    }
    return 'Mozilla/5.0 (Linux; Android 13; Pixel 7) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/124.0.0.0 Mobile Safari/537.36 EvairSIM/1.0';
  }
}

/// Full-screen branded splash shown while the first H5 paint is in flight.
///
/// The loading indicator is deliberately *not* a generic circular spinner —
/// for a SIM-card app, signal-strength bars rising & falling is both
/// thematically on-brand and visually more engaging than a donut.
class _SplashOverlay extends StatelessWidget {
  const _SplashOverlay();

  @override
  Widget build(BuildContext context) {
    // Scale the logo to 70% of screen width so the wide "EvairSIM"
    // wordmark reads comfortably on every device class without
    // touching the edges. `BoxFit.contain` preserves aspect ratio.
    final width = MediaQuery.of(context).size.width * 0.7;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage('assets/icon/splash_logo.png'),
            width: width,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          const _SignalBarsLoader(),
        ],
      ),
    );
  }
}

/// Animated cellular-signal-strength bars. Four bars grow and shrink in a
/// staggered wave, echoing the "📶" glyph. Pure Dart animation — no extra
/// packages, under 2 kB at runtime.
class _SignalBarsLoader extends StatefulWidget {
  const _SignalBarsLoader();

  @override
  State<_SignalBarsLoader> createState() => _SignalBarsLoaderState();
}

class _SignalBarsLoaderState extends State<_SignalBarsLoader>
    with TickerProviderStateMixin {
  static const _barCount = 4;
  static const _barWidth = 8.0;
  static const _barGap = 5.0;
  // Maximum heights for each bar (shortest on the left, tallest on the
  // right) so the resting shape reads as a classic signal icon.
  static const _barHeights = <double>[14, 22, 30, 38];
  static const _cycleDuration = Duration(milliseconds: 1100);

  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_barCount, (i) {
      final c = AnimationController(vsync: this, duration: _cycleDuration);
      // Stagger each bar's start so the wave visibly travels left→right.
      Future.delayed(Duration(milliseconds: i * 140), () {
        if (mounted) c.repeat(reverse: true);
      });
      return c;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _barHeights.last,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < _barCount; i++) ...[
            if (i > 0) const SizedBox(width: _barGap),
            AnimatedBuilder(
              animation: _controllers[i],
              builder: (_, __) {
                // Each bar oscillates between 30% and 100% of its max
                // height, producing a smooth wave without any bar ever
                // disappearing.
                final t = _controllers[i].value;
                final scale = 0.3 + 0.7 * t;
                return Container(
                  width: _barWidth,
                  height: _barHeights[i] * scale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6600),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Shown when the main frame fails to load (airplane mode, DNS, 5xx, …).
class _ErrorOverlay extends StatelessWidget {
  const _ErrorOverlay({
    required this.onRetry,
    required this.isDark,
    this.message,
  });

  final VoidCallback onRetry;
  final String? message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    // Pulled from the same palette as the H5 `dark:` styles so the error
    // screen doesn't jar the user when swapping between themes. Title is
    // high-contrast, body is the usual muted gray, Retry keeps the brand
    // orange in both modes.
    final bgColor =
        isDark ? const Color(0xFF0B1120) : const Color(0xFFFFFFFF);
    final titleColor =
        isDark ? const Color(0xFFE5E7EB) : const Color(0xFF111827);
    final bodyColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF666666);
    final iconColor =
        isDark ? const Color(0xFF64748B) : const Color(0xFF999999);

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 64,
            color: iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            "Can't reach EvairSIM right now",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message ?? 'Check your internet connection and try again.',
            style: TextStyle(fontSize: 14, color: bodyColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6600),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
