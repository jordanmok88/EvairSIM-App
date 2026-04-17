import 'package:dio/dio.dart';

/// Wraps the user-SIM endpoints. We prefer /v1/h5 because its payload is
/// richer, falling back to /v1/app when the H5 endpoint is not available.
class SimApi {
  SimApi(this._dio);

  final Dio _dio;

  static const String _h5 = '/v1/h5';
  static const String _app = '/v1/app';

  Future<Response<Map<String, dynamic>>> listSims() =>
      _dio.get<Map<String, dynamic>>('$_h5/user/sims');

  Future<Response<Map<String, dynamic>>> esimDetail(String iccid) =>
      _dio.get<Map<String, dynamic>>('$_h5/esim/$iccid');

  Future<Response<Map<String, dynamic>>> esimUsage(String iccid) =>
      _dio.get<Map<String, dynamic>>('$_h5/esim/$iccid/usage');

  Future<Response<Map<String, dynamic>>> bindSim({required String iccid}) =>
      _dio.post<Map<String, dynamic>>(
        '$_app/users/bind-sim',
        data: {'iccid': iccid},
      );

  Future<Response<Map<String, dynamic>>> unbindSim({required String iccid}) =>
      _dio.post<Map<String, dynamic>>(
        '$_app/users/unbind-sim',
        data: {'iccid': iccid},
      );

  Future<Response<Map<String, dynamic>>> rechargePackages() =>
      _dio.get<Map<String, dynamic>>('$_app/recharge-packages');

  Future<Response<Map<String, dynamic>>> createRechargeOrder({
    required String iccid,
    required String packageCode,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_h5/orders/topup',
        data: {'iccid': iccid, 'package_code': packageCode},
      );
}
