import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/auth_providers.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/forms/brand_text_field.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = useTextEditingController();
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final confirmCtrl = useTextEditingController();
    final obscure = useState(true);
    final auth = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    Future<void> submit() async {
      final ok = await controller.register(
        email: emailCtrl.text,
        password: passwordCtrl.text,
        confirmPassword: confirmCtrl.text,
        name: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
      );
      if (!context.mounted) return;
      if (ok) context.go(RouteNames.home);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(AppRadius.r16),
                  boxShadow: AppShadows.subtle,
                ),
                child: const Icon(
                  Icons.person_add_alt_1_outlined,
                  color: AppColors.brandOrange,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Create account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Join EvairSIM in 30 seconds',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.xxl),
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
                hint: 'At least 8 characters',
                icon: Icons.lock_outline,
                obscureText: obscure.value,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
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
              if (auth.error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errorBg,
                    borderRadius: BorderRadius.circular(AppRadius.r10),
                    border: Border.all(color: AppColors.errorBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 18),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          auth.error!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Create account',
                isLoading: auth.isLoading,
                onPressed: submit,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: AppColors.brandOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
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
