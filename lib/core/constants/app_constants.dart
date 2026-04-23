/// Compile-time constants for the native shell.
///
/// After the 2026-04 WebView migration, the APP no longer talks to Laravel
/// directly — every screen is rendered by the H5 site inside a full-screen
/// `InAppWebView`. Only the URL of that H5 site is configurable here.
abstract class AppConstants {
  static const String appName = 'EvairSIM';

  /// URL loaded by `WebViewShellPage`. Override for local dev with e.g.
  ///   flutter run -d chrome --dart-define=H5_URL=http://127.0.0.1:3000
  ///   flutter run -d ios-sim --dart-define=H5_URL=http://127.0.0.1:3000
  ///   flutter run -d android-emu --dart-define=H5_URL=http://10.0.2.2:3000
  /// Production default points at the public H5 deployment.
  static const String h5Url = String.fromEnvironment(
    'H5_URL',
    defaultValue: 'https://evair.zhhwxt.cn/',
  );

  // Company (used for error/fallback screens only).
  static const String supportEmail = 'service@evairdigital.com';
  static const String websiteUrl = 'https://evairdigital.com';
}
