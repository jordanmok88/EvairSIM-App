import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/auth_providers.dart';
import 'login_modal.dart';

/// Gate an authenticated action.
///
/// If the current user is already signed in, resolves `true` immediately.
/// Otherwise opens the [LoginModal]; resolves `true` only if the user
/// successfully signs in / registers in the modal.
///
/// Typical usage:
///
/// ```dart
/// onTap: () async {
///   if (!await requireAuth(context, ref)) return;
///   context.push(RouteNames.profile);
/// }
/// ```
Future<bool> requireAuth(
  BuildContext context,
  WidgetRef ref, {
  LoginModalMode initialMode = LoginModalMode.signIn,
}) async {
  final auth = ref.read(authControllerProvider);
  if (auth.isAuthenticated) return true;
  if (!context.mounted) return false;
  return LoginModal.show(context, initialMode: initialMode);
}
