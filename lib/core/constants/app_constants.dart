abstract class AppConstants {
  static const String appName = 'EvairSIM';

  // Backend API (Laravel) — root, so each call can choose /v1/app/... or /v1/h5/...
  // /v1/app endpoints: auth, users
  // /v1/h5 endpoints:  packages, countries (public), orders, esims
  static const String baseUrl = 'https://evair.zhhwxt.cn/api';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // SecureStorage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // Paging
  static const int defaultPageSize = 20;

  // Company
  static const String supportEmail = 'service@evairdigital.com';
  static const String websiteUrl = 'https://evairdigital.com';
}
