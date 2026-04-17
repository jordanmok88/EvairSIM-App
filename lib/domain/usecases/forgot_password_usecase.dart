import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  ForgotPasswordUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, Unit>> call({required String email}) {
    if (email.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Email is required')));
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      return Future.value(const Left(ValidationFailure('Invalid email')));
    }
    return _repo.forgotPassword(email: email.trim());
  }
}
