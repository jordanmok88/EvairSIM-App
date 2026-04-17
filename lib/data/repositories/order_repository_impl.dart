import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../core/network/response_envelope.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/payment_session.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_api.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._api);
  final OrderApi _api;

  @override
  Future<Either<Failure, AppOrder>> createEsimOrder({
    required String packageCode,
    required String email,
    int quantity = 1,
  }) =>
      _guard(() async {
        final resp = await _api.createEsimOrder(
          packageCode: packageCode,
          email: email,
          quantity: quantity,
        );
        ResponseEnvelope.throwIfError(resp);
        return AppOrder.fromJson(ResponseEnvelope.dataMap(resp));
      });

  @override
  Future<Either<Failure, PaymentSession>> createPaymentSession({
    required String orderNo,
  }) =>
      _guard(() async {
        final resp = await _api.createPaymentSession(orderNo: orderNo);
        ResponseEnvelope.throwIfError(resp);
        return PaymentSession.fromJson(ResponseEnvelope.dataMap(resp));
      });

  @override
  Future<Either<Failure, List<AppOrder>>> listOrders() => _guard(() async {
        final resp = await _api.listOrders();
        ResponseEnvelope.throwIfError(resp);
        final list = ResponseEnvelope.dataList(resp);
        return list
            .whereType<Map>()
            .map((m) => AppOrder.fromJson(Map<String, dynamic>.from(m)))
            .toList(growable: false);
      });

  @override
  Future<Either<Failure, Unit>> sendReceiptEmail({required String orderNo}) =>
      _guard(() async {
        final resp = await _api.sendEsimDeliveryEmail(orderNo: orderNo);
        // Best-effort; even on failure we don't block the UI.
        ResponseEnvelope.throwIfError(resp);
        return unit;
      });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Right(await body());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } on DioException catch (e) {
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
