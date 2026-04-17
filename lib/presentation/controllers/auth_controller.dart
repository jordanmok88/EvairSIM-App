import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/user.dart';
import '../providers/auth_providers.dart';

@immutable
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;
  final bool bootstrapped;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.bootstrapped = false,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    bool clearUser = false,
    String? error,
    bool clearError = false,
    bool? bootstrapped,
  }) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        user: clearUser ? null : (user ?? this.user),
        error: clearError ? null : (error ?? this.error),
        bootstrapped: bootstrapped ?? this.bootstrapped,
      );

  bool get isAuthenticated => user != null;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState()) {
    _bootstrap();
  }

  final Ref _ref;

  /// On app launch, silently call /users/me if a token is stored.
  Future<void> _bootstrap() async {
    final repo = _ref.read(authRepositoryProvider);
    final hasSession = await repo.hasSession();
    if (!hasSession) {
      state = state.copyWith(bootstrapped: true);
      return;
    }
    final result = await repo.me();
    result.fold(
      (failure) =>
          state = state.copyWith(bootstrapped: true, clearUser: true),
      (user) => state = state.copyWith(bootstrapped: true, user: user),
    );
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result =
        await _ref.read(loginUseCaseProvider).call(email: email, password: password);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user, clearError: true);
        return true;
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    String? name,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _ref.read(registerUseCaseProvider).call(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          name: name,
        );
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user, clearError: true);
        return true;
      },
    );
  }

  Future<bool> forgotPassword({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result =
        await _ref.read(forgotPasswordUseCaseProvider).call(email: email);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, clearError: true);
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _ref.read(logoutUseCaseProvider).call();
    state = const AuthState(bootstrapped: true);
  }

  void clearError() => state = state.copyWith(clearError: true);
}
