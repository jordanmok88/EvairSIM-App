abstract class RouteNames {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main tabs
  static const String shop = '/shop';
  static const String mySims = '/my-sims';
  static const String profile = '/profile';

  // Activation flows (primary product surfaces post-April-2026 pivot)
  /// PCCW physical SIM activation wizard (Scan → Confirm → Done).
  static const String physicalSim = '/physical-sim';

  /// Red Tea eSIM "connect" — user pastes an ICCID + LPA code they
  /// received via email / admin portal to add the eSIM to their account.
  static const String connectEsim = '/connect-esim';

  // Shop sub-routes
  // NOTE: `countryPackages` route removed in the April 2026 pivot — the app
  // no longer sells eSIMs by country. Use `physicalSim` or `connectEsim`
  // instead, depending on the SIM type.

  // Checkout sub-routes
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';

  // Profile sub-routes
  static const String inbox = '/inbox';
  static const String contact = '/contact';
  static const String liveChat = '/live-chat';
  static const String orders = '/orders';
}
