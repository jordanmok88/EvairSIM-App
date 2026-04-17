import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Email is required')));
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      return Future.value(const Left(ValidationFailure('Invalid email')));
    }
    if (password.isEmpty) {
      return Future.value(const Left(ValidationFailure('Password is required')));
    }
    if (password.length < 8) {
      return Future.value(
          const Left(ValidationFailure('Password must be at least 8 characters')));
    }
    return _repo.login(email: email.trim(), password: password);
  }
}
