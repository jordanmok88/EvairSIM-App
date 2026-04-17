import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this._repo);

  final AuthRepository _repo;

  Future<Either<Failure, Unit>> call() => _repo.logout();
}
