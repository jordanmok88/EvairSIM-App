import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/app_constants.dart';
import 'secure_storage_provider.dart';

/// Attaches bearer token to outgoing requests.
/// On 401, clears stored tokens so the UI can redirect to login.
class ApiInterceptor extends Interceptor {
  ApiInterceptor(this.ref);

  final Ref ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final storage = ref.read(secureStorageProvider);
      await storage.delete(key: AppConstants.accessTokenKey);
      await storage.delete(key: AppConstants.refreshTokenKey);
    }
    handler.next(err);
  }
}
