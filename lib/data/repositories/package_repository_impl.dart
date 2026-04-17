import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/error/backend_error_messages.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/package.dart';
import '../../domain/repositories/package_repository.dart';
import '../datasources/remote/package_api.dart';

class PackageRepositoryImpl implements PackageRepository {
  PackageRepositoryImpl(this._api);

  final PackageApi _api;

  @override
  Future<Either<Failure, List<Country>>> listCountries() => _guard(() async {
        final resp = await _api.locations();
        _ensureSuccess(resp);
        final data = (resp.data?['data'] as Map?) ?? const {};
        final single = (data['single_countries'] as List?) ?? const [];
        return single
            .whereType<Map>()
            .map((m) => Country.fromJson(Map<String, dynamic>.from(m)))
            .toList(growable: false);
      });

  @override
  Future<Either<Failure, List<Package>>> listPackages({
    String? location,
    String? type,
    int page = 1,
    int perPage = 20,
  }) =>
      _guard(() async {
        final resp = await _api.packages(
          location: location,
          type: type,
          page: page,
          perPage: perPage,
        );
        _ensureSuccess(resp);
        return _extractPackages(resp.data?['data']);
      });

  @override
  Future<Either<Failure, List<Package>>> listHotPackages({int limit = 10}) =>
      _guard(() async {
        final resp = await _api.hotPackages(limit: limit);
        _ensureSuccess(resp);
        return _extractPackages(resp.data?['data']);
      });

  // ── helpers ──
  List<Package> _extractPackages(Object? data) {
    final raw = data is Map ? (data['packages'] as List? ?? const []) : const [];
    return raw
        .whereType<Map>()
        .map((m) => Package.fromJson(Map<String, dynamic>.from(m)))
        .toList(growable: false);
  }

  void _ensureSuccess(Response<Map<String, dynamic>> resp) {
    final body = resp.data;
    final code = body?['code']?.toString() ?? '';
    final msg = body?['msg']?.toString() ?? '';

    final isSuccess = code == '0' ||
        code == '200' ||
        code == '201' ||
        code.toUpperCase() == 'SUCCESS' ||
        code.toUpperCase() == 'OK';
    if (isSuccess) return;

    final friendly =
        BackendErrorMessages.translate(code: code, msg: msg, dataErrors: null);
    throw ServerException(friendly, code: resp.statusCode);
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Right(await body());
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
