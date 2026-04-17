abstract class RouteNames {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main tabs
  static const String shop = '/shop';
  static const String mySims = '/my-sims';
  static const String physicalSim = '/physical-sim';
  static const String profile = '/profile';

  // Shop sub-routes
  /// Base path for country-specific package listing. Full path: `/shop/country/:code`.
  static const String countryPackages = '/shop/country';

  // Checkout sub-routes
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';

  // Profile sub-routes
  static const String inbox = '/inbox';
  static const String contact = '/contact';
  static const String orders = '/orders';
}
