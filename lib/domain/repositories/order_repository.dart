import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/order.dart';
import '../entities/payment_session.dart';

abstract class OrderRepository {
  Future<Either<Failure, AppOrder>> createEsimOrder({
    required String packageCode,
    required String email,
    int quantity,
  });

  Future<Either<Failure, PaymentSession>> createPaymentSession({
    required String orderNo,
  });

  Future<Either<Failure, List<AppOrder>>> listOrders();

  Future<Either<Failure, Unit>> sendReceiptEmail({required String orderNo});
}
