import 'package:dio/dio.dart';

/// `GET /v1/h5/notifications` — public endpoint, no auth required.
/// Returns an active list of notifications (most recent 50) ordered by
/// created_at DESC. See `routes/v1/h5/public.php` + `H5\NotificationController`.
class NotificationApi {
  NotificationApi(this._dio);
  final Dio _dio;

  static const String _prefix = '/v1/h5';

  Future<Response<Map<String, dynamic>>> list() =>
      _dio.get<Map<String, dynamic>>('$_prefix/notifications');
}
