import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/auth_providers.dart';
import '../buttons/primary_button.dart';
import '../forms/brand_text_field.dart';

enum LoginModalMode { signIn, signUp }

/// Branded bottom-sheet login / register experience.
///
/// Used for the H5-parity "guest-first" flow: the app opens on Home, and
/// this modal is presented on demand when a gated action (profile, checkout,
/// SIM activation) requires an authenticated user.
///
/// Pops with `true` on successful login/register so callers can continue
/// their gated action, or `false` / `null` if the user dismisses.
class LoginModal extends HookConsumerWidget {
  const LoginModal({
    super.key,
    this.initialMode = LoginModalMode.signIn,
  });

  final LoginModalMode initialMode;

  static Future<bool> show(
    BuildContext context, {
    LoginModalMode initialMode = LoginModalMode.signIn,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => LoginModal(initialMode: initialMode),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = useState(initialMode);

    final nameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final confirmCtrl = useTextEditingController();
    final obscure = useState(true);

    final auth = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    useEffect(() {
      // Clear any stale error when the modal first opens.
      Future.microtask(controller.clearError);
      return null;
    }, const []);

    Future<void> submit() async {
      final isSignIn = mode.value == LoginModalMode.signIn;
      final ok = isSignIn
          ? await controller.login(
              email: emailCtrl.text.trim(),
              password: passwordCtrl.text,
            )
          : await controller.register(
              email: emailCtrl.text.trim(),
              password: passwordCtrl.text,
              confirmPassword: confirmCtrl.text,
              name: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
            );
      if (!context.mounted) return;
      if (ok) Navigator.of(context).pop(true);
    }

    return Padding(
      // Push the sheet up above the keyboard when typing.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: AppRadius.bottomSheet,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.sm,
            AppSpacing.pageHorizontal,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8, bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.borderDefault,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),

              _ModeToggle(
                value: mode.value,
                onChanged: (m) {
                  mode.value = m;
                  controller.clearError();
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              Text(
                mode.value == LoginModalMode.signIn
                    ? 'Welcome back'
                    : 'Create your account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                mode.value == LoginModalMode.signIn
                    ? 'Sign in to manage your eSIMs'
                    : 'Join EvairSIM in 30 seconds',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),

              if (mode.value == LoginModalMode.signUp) ...[
                const _Label('NAME (OPTIONAL)'),
                const SizedBox(height: AppSpacing.sm),
                BrandTextField(
                  controller: nameCtrl,
                  hint: 'Your name',
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              const _Label('EMAIL'),
              const SizedBox(height: AppSpacing.sm),
              BrandTextField(
                controller: emailCtrl,
                hint: 'you@example.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: AppSpacing.lg),

              const _Label('PASSWORD'),
              const SizedBox(height: AppSpacing.sm),
              BrandTextField(
                controller: passwordCtrl,
                hint: mode.value == LoginModalMode.signIn
                    ? 'Your password'
                    : 'At least 8 characters',
                icon: Icons.lock_outline,
                obscureText: obscure.value,
                textInputAction: mode.value == LoginModalMode.signIn
                    ? TextInputAction.done
                    : TextInputAction.next,
                autofillHints: mode.value == LoginModalMode.signIn
                    ? const [AutofillHints.password]
                    : const [AutofillHints.newPassword],
                onSubmitted:
                    mode.value == LoginModalMode.signIn ? (_) => submit() : null,
                suffix: IconButton(
                  icon: Icon(
                    obscure.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => obscure.value = !obscure.value,
                ),
              ),

              if (mode.value == LoginModalMode.signUp) ...[
                const SizedBox(height: AppSpacing.lg),
                const _Label('CONFIRM PASSWORD'),
                const SizedBox(height: AppSpacing.sm),
                BrandTextField(
                  controller: confirmCtrl,
                  hint: 'Re-enter password',
                  icon: Icons.lock_outline,
                  obscureText: obscure.value,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => submit(),
                ),
              ],

              if (mode.value == LoginModalMode.signIn) ...[
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      context.push(RouteNames.forgotPassword);
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: AppColors.brandOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              if (auth.error != null) ...[
                const SizedBox(height: AppSpacing.md),
                _ErrorBanner(message: auth.error!),
              ],

              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: mode.value == LoginModalMode.signIn
                    ? 'Sign in'
                    : 'Create account',
                isLoading: auth.isLoading,
                onPressed: submit,
              ),

              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mode.value == LoginModalMode.signIn
                        ? "Don't have an account? "
                        : 'Already have an account? ',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      mode.value = mode.value == LoginModalMode.signIn
                          ? LoginModalMode.signUp
                          : LoginModalMode.signIn;
                      controller.clearError();
                    },
                    child: Text(
                      mode.value == LoginModalMode.signIn
                          ? 'Sign up'
                          : 'Sign in',
                      style: const TextStyle(
                        color: AppColors.brandOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.value, required this.onChanged});
  final LoginModalMode value;
  final ValueChanged<LoginModalMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final half = (c.maxWidth - 8) / 2;
        final isSignIn = value == LoginModalMode.signIn;
        return Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.fillLight,
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                left: isSignIn ? 0 : half,
                top: 0,
                bottom: 0,
                width: half,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange,
                    borderRadius: BorderRadius.circular(AppRadius.r10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33FF6600),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _Seg(
                      label: 'Sign in',
                      selected: isSignIn,
                      onTap: () => onChanged(LoginModalMode.signIn),
                    ),
                  ),
                  Expanded(
                    child: _Seg(
                      label: 'Create account',
                      selected: !isSignIn,
                      onTap: () => onChanged(LoginModalMode.signUp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Seg extends StatelessWidget {
  const _Seg({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r10),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: selected ? AppColors.white : AppColors.textSecondary,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(AppRadius.r10),
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
