import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String confirmPassword,
    String? name,
  }) {
    if (email.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Email is required')));
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      return Future.value(const Left(ValidationFailure('Invalid email')));
    }
    if (password.length < 8) {
      return Future.value(
          const Left(ValidationFailure('Password must be at least 8 characters')));
    }
    if (password != confirmPassword) {
      return Future.value(
          const Left(ValidationFailure('Passwords do not match')));
    }
    return _repo.register(
      email: email.trim(),
      password: password,
      passwordConfirmation: confirmPassword,
      name: name?.trim(),
    );
  }
}
