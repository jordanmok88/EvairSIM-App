import 'package:dio/dio.dart';

/// Wraps order + payment endpoints. Uses the H5 route group because the
/// App route group requires a cart-based order flow; H5 supports direct
/// package purchase.  The same Sanctum token works for both guards.
class OrderApi {
  OrderApi(this._dio);

  final Dio _dio;

  static const String _h5 = '/v1/h5';
  static const String _app = '/v1/app';

  /// Creates a pending-payment order from a single package code.
  Future<Response<Map<String, dynamic>>> createEsimOrder({
    required String packageCode,
    required String email,
    int quantity = 1,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_h5/orders/esim',
        data: {
          'package_code': packageCode,
          'quantity': quantity,
          'email': email,
        },
      );

  Future<Response<Map<String, dynamic>>> createPaymentSession({
    required String orderNo,
    String paymentMethod = 'stripe',
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_h5/payments/create',
        data: {
          'order_no': orderNo,
          'payment_method': paymentMethod,
        },
      );

  Future<Response<Map<String, dynamic>>> listOrders({
    int page = 1,
    int perPage = 20,
  }) =>
      _dio.get<Map<String, dynamic>>(
        '$_app/orders',
        queryParameters: {'page': page, 'per_page': perPage},
      );

  Future<Response<Map<String, dynamic>>> getOrder(int id) =>
      _dio.get<Map<String, dynamic>>('$_app/orders/$id');

  /// Triggers the H5 email receipt. Safe to call multiple times.
  Future<Response<Map<String, dynamic>>> sendEsimDeliveryEmail({
    required String orderNo,
  }) =>
      _dio.post<Map<String, dynamic>>(
        '$_h5/email/esim-delivery',
        data: {'order_no': orderNo},
      );
}
