import 'package:dio/dio.dart';

/// Wraps the user-SIM endpoints. We prefer /v1/h5 because its payload is
/// richer, and /v1/app (auth:app) for the admin-portal-managed surfaces
/// (recharge packages, recharge orders, payment intents).
///
/// Our bearer token works on both guards so mixing is fine.
class SimApi {
  SimApi(this._dio);

  final Dio _dio;

  static const String _h5 = '/v1/h5';
  static const String _app = '/v1/app';

  // ──────────────────────────────────────────────
  // SIM list / detail / usage
  // ──────────────────────────────────────────────

  Future<Response<Map<String, dynamic>>> listSims() =>
      _dio.get<Map<String, dynamic>>('$_h5/user/sims');

  Future<Response<Map<String, dynamic>>> esimDetail(String iccid) =>
      _dio.get<Map<String, dynamic>>('$_h5/esim/$iccid');

  Future<Response<Map<String, dynamic>>> esimUsage(String iccid) =>
      _dio.get<Map<String, dynamic>>('$_h5/esim/$iccid/usage');

  // ──────────────────────────────────────────────
  // Bind / unbind
  // ──────────────────────────────────────────────

  /// Binds a SIM (PCCW physical OR Red Tea eSIM) to the current user.
  /// [activationCode] is optional and only relevant for eSIMs — the backend
  /// currently stores it for reference (the check is marked TODO in
  /// `AppUserController::bindSim`).
  Future<Response<Map<String, dynamic>>> bindSim({
    required String iccid,
    String? activationCode,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_app/users/bind-sim',
        data: {
          'iccid': iccid,
          if (activationCode != null && activationCode.isNotEmpty)
            'activation_code': activationCode,
        },
      );

  Future<Response<Map<String, dynamic>>> unbindSim({required String iccid}) =>
      _dio.post<Map<String, dynamic>>(
        '$_app/users/unbind-sim',
        data: {'iccid': iccid},
      );

  // ──────────────────────────────────────────────
  // Recharge packages (admin-portal-managed 充值套餐管理)
  // ──────────────────────────────────────────────

  /// Admin-managed recharge package list.  Filtered by supplier:
  ///   - `supplierType: 'pccw'`       → PCCW physical SIM top-ups
  ///   - `supplierType: 'esimaccess'` → Red Tea eSIM top-ups (default-safe)
  Future<Response<Map<String, dynamic>>> rechargePackages({
    String supplierType = 'pccw',
  }) =>
      _dio.get<Map<String, dynamic>>(
        '$_app/recharge-packages',
        queryParameters: {'supplier_type': supplierType},
      );

  /// Creates a `recharge_records` entry. Needs [supplierType] because the
  /// controller uses it to resolve which template table to snapshot
  /// (`packages` for PCCW, `supplier_packages` for Red Tea).
  Future<Response<Map<String, dynamic>>> createRechargeOrder({
    required String iccid,
    required String supplierType,
    required String packageCode,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_app/recharge',
        data: {
          'iccid': iccid,
          'supplier_type': supplierType,
          'package_code': packageCode,
        },
      );

  /// Creates a Stripe PaymentIntent for a pending recharge order.
  /// Default `payment_method` is `stripe`.
  Future<Response<Map<String, dynamic>>> payRecharge({
    required int rechargeId,
    String paymentMethod = 'stripe',
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_app/recharge/$rechargeId/pay',
        data: {'payment_method': paymentMethod},
      );

  /// Paginated recharge history for the current user.
  Future<Response<Map<String, dynamic>>> rechargeRecords({
    String? status,
    int perPage = 20,
  }) =>
      _dio.get<Map<String, dynamic>>(
        '$_app/recharge-records',
        queryParameters: {
          'per_page': perPage,
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );

  Future<Response<Map<String, dynamic>>> rechargeRecord(int id) =>
      _dio.get<Map<String, dynamic>>('$_app/recharge-records/$id');
}
