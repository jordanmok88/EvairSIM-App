import 'package:dio/dio.dart';

/// Thin Dio wrapper for /v1/h5/packages endpoints.
/// These are public (no auth) and return the classic
/// `{code, msg, data}` envelope with `code: 0` for success.
class PackageApi {
  PackageApi(this._dio);

  final Dio _dio;

  static const String _prefix = '/v1/h5';

  /// Returns `{ single_countries: [{code,name}], multi_countries?: [...] }`.
  Future<Response<Map<String, dynamic>>> locations() =>
      _dio.get<Map<String, dynamic>>('$_prefix/packages/locations');

  /// Paginated list, supports `location`, `type`, `page`, `per_page`.
  Future<Response<Map<String, dynamic>>> packages({
    String? location,
    String? type,
    int page = 1,
    int perPage = 20,
  }) =>
      _dio.get<Map<String, dynamic>>(
        '$_prefix/packages',
        queryParameters: {
          if (location != null) 'location': location,
          if (type != null) 'type': type,
          'page': page,
          'per_page': perPage,
        },
      );

  Future<Response<Map<String, dynamic>>> hotPackages({int limit = 10}) =>
      _dio.get<Map<String, dynamic>>(
        '$_prefix/packages/hot',
        queryParameters: {'limit': limit},
      );
}
