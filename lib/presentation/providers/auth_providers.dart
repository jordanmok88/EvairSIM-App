import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/network/secure_storage_provider.dart';
import '../../data/datasources/remote/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../controllers/auth_controller.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authApiProvider),
    ref.watch(secureStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>(
    (ref) => LoginUseCase(ref.watch(authRepositoryProvider)));
final registerUseCaseProvider = Provider<RegisterUseCase>(
    (ref) => RegisterUseCase(ref.watch(authRepositoryProvider)));
final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>(
    (ref) => ForgotPasswordUseCase(ref.watch(authRepositoryProvider)));
final logoutUseCaseProvider = Provider<LogoutUseCase>(
    (ref) => LogoutUseCase(ref.watch(authRepositoryProvider)));

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
