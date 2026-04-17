import 'package:dio/dio.dart';

import '../error/backend_error_messages.dart';
import '../error/exceptions.dart';

/// Shared helpers for the Laravel `{code, msg, data}` envelope, which is
/// inconsistent across the codebase:
/// - /v1/app/* returns `code: "200"|"201"|"AUTH_001"` (string)
/// - /v1/h5/*  returns `code: 0|3001|"SYSTEM_001"` (int or string)
abstract class ResponseEnvelope {
  static bool isSuccess(Response response) {
    final body = response.data;
    if (body is! Map) return false;
    final code = body['code']?.toString() ?? '';
    return code == '0' ||
        code == '200' ||
        code == '201' ||
        code.toUpperCase() == 'SUCCESS' ||
        code.toUpperCase() == 'OK';
  }

  /// Throws [ServerException] or [UnauthorizedException] when the response
  /// represents a business error.
  static void throwIfError(Response response) {
    if (isSuccess(response)) return;
    final body = response.data;
    final code = (body is Map ? body['code']?.toString() : null) ?? '';
    final msg = (body is Map ? body['msg']?.toString() : null) ?? '';
    final dataErrors =
        (body is Map && body['data'] is Map) ? (body['data'] as Map)['errors'] : null;

    final friendly = BackendErrorMessages.translate(
      code: code,
      msg: msg,
      dataErrors: dataErrors,
    );
    final status = response.statusCode ?? 0;
    if (status == 401 || code == 'AUTH_001' || code == 'AUTH_002') {
      throw UnauthorizedException(friendly);
    }
    throw ServerException(friendly, code: status);
  }

  static Map<String, dynamic> dataMap(Response response) {
    final d = (response.data is Map ? response.data['data'] : null);
    return d is Map ? Map<String, dynamic>.from(d) : <String, dynamic>{};
  }

  static List<dynamic> dataList(Response response, {String key = 'list'}) {
    final d = response.data is Map ? response.data['data'] : null;
    if (d is List) return d;
    if (d is Map && d[key] is List) return d[key] as List;
    return const [];
  }
}
