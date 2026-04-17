import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/backend_error_messages.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._storage);

  final AuthApi _api;
  final FlutterSecureStorage _storage;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) =>
      _guard(() async {
        final resp = await _api.login(email: email, password: password);
        return _handleAuthResponse(resp);
      });

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? name,
  }) =>
      _guard(() async {
        final resp = await _api.register(
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          name: name,
          source: _platformSource(),
        );
        return _handleAuthResponse(resp);
      });

  int _platformSource() {
    if (kIsWeb) return 4;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 1;
      case TargetPlatform.android:
        return 2;
      default:
        return 4;
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) =>
      _guard(() async {
        final resp = await _api.forgotPassword(email: email);
        _ensureSuccess(resp);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String password,
  }) =>
      _guard(() async {
        final resp = await _api.resetPassword(
          email: email,
          token: token,
          password: password,
        );
        _ensureSuccess(resp);
        return unit;
      });

  @override
  Future<Either<Failure, User>> me() => _guard(() async {
        final resp = await _api.me();
        final body = resp.data ?? const {};
        _ensureSuccess(resp);
        final data = body['data'] as Map<String, dynamic>?;
        if (data == null) {
          throw const FormatException('No user data in /users/me response');
        }
        return User.fromJson(data);
      });

  @override
  Future<Either<Failure, Unit>> logout() => _guard(() async {
        try {
          await _api.logout();
        } catch (_) {
          // Ignore backend error — we clear local tokens regardless.
        }
        await _storage.delete(key: AppConstants.accessTokenKey);
        await _storage.delete(key: AppConstants.refreshTokenKey);
        return unit;
      });

  @override
  Future<bool> hasSession() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  // ── helpers ──

  Future<User> _handleAuthResponse(Response<Map<String, dynamic>> resp) async {
    _ensureSuccess(resp);
    final body = resp.data ?? const {};
    final data = body['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw const FormatException('Auth response missing "data" field');
    }

    final token = (data['access_token'] ?? data['token']) as String?;
    if (token != null && token.isNotEmpty) {
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: token,
      );
    }
    final refresh = data['refresh_token'] as String?;
    if (refresh != null && refresh.isNotEmpty) {
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: refresh,
      );
    }

    final userJson = data['user'] as Map<String, dynamic>?;
    if (userJson == null) {
      throw const FormatException('Auth response missing "user" field');
    }
    return User.fromJson(userJson);
  }

  void _ensureSuccess(Response<Map<String, dynamic>> resp) {
    final body = resp.data;
    final code = body?['code']?.toString() ?? '';
    final msg = body?['msg']?.toString() ?? '';
    final dataErrors =
        (body?['data'] is Map) ? (body!['data'] as Map)['errors'] : null;

    // Backend returns "200"/"201" (string) for success.
    final isSuccess = code == '200' ||
        code == '201' ||
        code == '0' ||
        code.toUpperCase() == 'SUCCESS' ||
        code.toUpperCase() == 'OK';
    if (isSuccess) return;

    final friendly = BackendErrorMessages.translate(
      code: code,
      msg: msg,
      dataErrors: dataErrors,
    );
    final status = resp.statusCode ?? 0;
    if (status == 401 || code == 'AUTH_001' || code == 'AUTH_002') {
      throw UnauthorizedException(friendly);
    }
    throw ServerException(friendly, code: status);
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      final result = await body();
      return Right(result);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } on DioException catch (e) {
      // Connection/SSL/timeout problems.
      final msg = e.message ?? e.error?.toString() ?? 'Network error';
      return Left(NetworkFailure(msg));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
