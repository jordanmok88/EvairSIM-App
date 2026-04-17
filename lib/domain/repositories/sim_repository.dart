import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/order.dart';
import '../entities/recharge_package.dart';
import '../entities/sim.dart';

abstract class SimRepository {
  Future<Either<Failure, List<Sim>>> listSims();

  Future<Either<Failure, Sim>> esimDetail(String iccid);

  Future<Either<Failure, Sim>> esimUsage(String iccid);

  Future<Either<Failure, Unit>> bindSim({required String iccid});

  Future<Either<Failure, Unit>> unbindSim({required String iccid});

  Future<Either<Failure, List<RechargePackage>>> rechargePackages();

  Future<Either<Failure, AppOrder>> createTopUpOrder({
    required String iccid,
    required String packageCode,
  });
}
