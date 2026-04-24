/// Compile-time constants for the native shell.
///
/// After the 2026-04 WebView migration, the APP no longer talks to Laravel
/// directly — every screen is rendered by the H5 site inside a full-screen
/// `InAppWebView`. Only the URL of that H5 site is configurable here.
abstract class AppConstants {
  static const String appName = 'EvairSIM';

  /// URL loaded by `WebViewShellPage`. Override for local dev with e.g.
  ///   flutter run -d chrome --dart-define=H5_URL=http://127.0.0.1:3000/app
  ///   flutter run -d ios-sim --dart-define=H5_URL=http://127.0.0.1:3000/app
  ///   flutter run -d android-emu --dart-define=H5_URL=http://10.0.2.2:3000/app
  /// Production default points at the public H5 deployment (Netlify).
  ///
  /// IMPORTANT — three gotchas, all learned the hard way:
  ///   1. Do NOT point this at `evair.zhhwxt.cn` — that host only runs
  ///      Laravel (the API) and does not serve the H5 SPA. Pointing the
  ///      native shell there shows Laravel's stock `welcome.blade.php`.
  ///   2. `https://evair-h5.netlify.app/` serves the `main` branch, which
  ///      may lag behind active development. The live "new version" with
  ///      Amazon storefront CTA etc. currently lives on the
  ///      `feature/api-integration` branch deploy. Keep this default in
  ///      sync with whichever branch is the de-facto production tip; once
  ///      `feature/api-integration` is merged into `main`, flip this back
  ///      to `https://evair-h5.netlify.app/app`.
  ///   3. The URL MUST end in `/app` (Phase 0 of the 2026-04-24 marketing/
  ///      app split). Browser visitors land at `/` and hit the marketing
  ///      surface; the native shell goes straight to `/app` so it never
  ///      sees the marketing layer. Forgetting the `/app` suffix makes the
  ///      app boot into what-will-become the marketing home. See
  ///      `Evair-H5/.cursor/rules/product-decisions.mdc` §Architecture.
  static const String h5Url = String.fromEnvironment(
    'H5_URL',
    defaultValue: 'https://feature-api-integration--evair-h5.netlify.app/app',
  );

  // Company (used for error/fallback screens only).
  static const String supportEmail = 'service@evairdigital.com';
  static const String websiteUrl = 'https://evairdigital.com';
}
