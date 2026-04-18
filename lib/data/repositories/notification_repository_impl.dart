import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../core/network/response_envelope.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notification_api.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._api);
  final NotificationApi _api;

  @override
  Future<Either<Failure, List<AppNotification>>> list() => _guard(() async {
        final resp = await _api.list();
        ResponseEnvelope.throwIfError(resp);
        return ResponseEnvelope.dataList(resp)
            .whereType<Map>()
            .map((m) => AppNotification.fromJson(Map<String, dynamic>.from(m)))
            .toList(growable: false);
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
