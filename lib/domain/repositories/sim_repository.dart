import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/payment_intent.dart';
import '../entities/recharge_order.dart';
import '../entities/recharge_package.dart';
import '../entities/sim.dart';

abstract class SimRepository {
  // ─── SIMs bound to the user ───
  Future<Either<Failure, List<Sim>>> listSims();
  Future<Either<Failure, Sim>> esimDetail(String iccid);
  Future<Either<Failure, Sim>> esimUsage(String iccid);

  /// Binds a SIM to the current user. Works for both PCCW physical SIMs
  /// (just [iccid]) and Red Tea eSIMs ([iccid] + optional [activationCode]
  /// parsed from an LPA string).
  Future<Either<Failure, Unit>> bindSim({
    required String iccid,
    String? activationCode,
  });

  Future<Either<Failure, Unit>> unbindSim({required String iccid});

  // ─── Top-up (admin-portal-managed recharge packages) ───

  /// Admin-managed recharge package list. Caller MUST pass the correct
  /// [supplierType] (`'pccw'` for physical SIMs, `'esimaccess'` for eSIMs).
  Future<Either<Failure, List<RechargePackage>>> rechargePackages({
    String supplierType = 'pccw',
  });

  /// Creates a pending recharge order ready for payment.
  Future<Either<Failure, RechargeOrder>> createRechargeOrder({
    required String iccid,
    required String supplierType,
    required String packageCode,
  });

  /// Creates a Stripe PaymentIntent for the given recharge order.
  Future<Either<Failure, PaymentIntent>> payRecharge({
    required int rechargeId,
    String paymentMethod = 'stripe',
  });

  /// Paginated recharge history.
  Future<Either<Failure, List<RechargeOrder>>> rechargeRecords({
    String? status,
    int perPage = 20,
  });

  Future<Either<Failure, RechargeOrder>> rechargeRecord(int id);
}
