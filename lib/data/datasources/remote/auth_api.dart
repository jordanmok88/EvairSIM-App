import 'package:dio/dio.dart';

import '../../models/auth/login_response_data.dart';

/// Thin Dio wrapper for auth endpoints on the Laravel backend.
/// Endpoints (prefix = `/v1/app` via Dio `baseUrl`):
///   POST /users/register
///   POST /users/login
///   POST /auth/forgot-password
///   POST /auth/reset-password
///   POST /users/logout           (auth required)
///   GET  /users/me               (auth required)
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  static const String _prefix = '/v1/app';

  Future<Response<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_prefix/users/login',
        data: {'email': email, 'password': password},
      );

  /// [source] is required by the Laravel `AppUserRegisterRequest`:
  /// 1=iOS, 2=Android, 3=H5, 4=Web. Defaults to 4 (web) for now; the
  /// caller should override for native builds.
  Future<Response<Map<String, dynamic>>> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? name,
    int source = 4,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_prefix/users/register',
        data: {
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (name != null) 'name': name,
          'source': source,
        },
      );

  Future<Response<Map<String, dynamic>>> forgotPassword({required String email}) =>
      _dio.post<Map<String, dynamic>>(
        '$_prefix/auth/forgot-password',
        data: {'email': email},
      );

  Future<Response<Map<String, dynamic>>> resetPassword({
    required String email,
    required String token,
    required String password,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_prefix/auth/reset-password',
        data: {'email': email, 'token': token, 'password': password},
      );

  Future<Response<Map<String, dynamic>>> me() =>
      _dio.get<Map<String, dynamic>>('$_prefix/users/me');

  Future<Response<Map<String, dynamic>>> logout() =>
      _dio.post<Map<String, dynamic>>('$_prefix/users/logout');

  /// Convenience to decode a login-style response into LoginResponseData.
  static LoginResponseData parseLoginData(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw const FormatException('Login response missing "data" field');
    }
    return LoginResponseData.fromJson(data);
  }
}
