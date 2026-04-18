import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../core/network/response_envelope.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/recharge_package.dart';
import '../../domain/entities/sim.dart';
import '../../domain/repositories/sim_repository.dart';
import '../datasources/remote/sim_api.dart';

class SimRepositoryImpl implements SimRepository {
  SimRepositoryImpl(this._api);
  final SimApi _api;

  @override
  Future<Either<Failure, List<Sim>>> listSims() => _guard(() async {
        final resp = await _api.listSims();
        ResponseEnvelope.throwIfError(resp);
        return ResponseEnvelope.dataList(resp)
            .whereType<Map>()
            .map((m) => Sim.fromJson(Map<String, dynamic>.from(m)))
            .toList(growable: false);
      });

  @override
  Future<Either<Failure, Sim>> esimDetail(String iccid) => _guard(() async {
        final resp = await _api.esimDetail(iccid);
        ResponseEnvelope.throwIfError(resp);
        return Sim.fromJson(ResponseEnvelope.dataMap(resp));
      });

  @override
  Future<Either<Failure, Sim>> esimUsage(String iccid) => _guard(() async {
        final resp = await _api.esimUsage(iccid);
        ResponseEnvelope.throwIfError(resp);
        return Sim.fromJson(
          {'iccid': iccid, ...ResponseEnvelope.dataMap(resp)},
        );
      });

  @override
  Future<Either<Failure, Unit>> bindSim({
    required String iccid,
    String? activationCode,
  }) =>
      _guard(() async {
        final resp = await _api.bindSim(
          iccid: iccid,
          activationCode: activationCode,
        );
        ResponseEnvelope.throwIfError(resp);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> unbindSim({required String iccid}) =>
      _guard(() async {
        final resp = await _api.unbindSim(iccid: iccid);
        ResponseEnvelope.throwIfError(resp);
        return unit;
      });

  @override
  Future<Either<Failure, List<RechargePackage>>> rechargePackages() =>
      _guard(() async {
        final resp = await _api.rechargePackages();
        ResponseEnvelope.throwIfError(resp);
        return ResponseEnvelope.dataList(resp)
            .whereType<Map>()
            .map((m) => RechargePackage.fromJson(Map<String, dynamic>.from(m)))
            .toList(growable: false);
      });

  @override
  Future<Either<Failure, AppOrder>> createTopUpOrder({
    required String iccid,
    required String packageCode,
  }) =>
      _guard(() async {
        final resp = await _api.createRechargeOrder(
          iccid: iccid,
          packageCode: packageCode,
        );
        ResponseEnvelope.throwIfError(resp);
        return AppOrder.fromJson(ResponseEnvelope.dataMap(resp));
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
