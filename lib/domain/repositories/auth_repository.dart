import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? name,
  });

  Future<Either<Failure, Unit>> forgotPassword({required String email});

  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String password,
  });

  Future<Either<Failure, User>> me();

  Future<Either<Failure, Unit>> logout();

  /// True when a token is stored locally.
  Future<bool> hasSession();
}
