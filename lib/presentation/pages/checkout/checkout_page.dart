import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/package.dart';
import '../../controllers/checkout_controller.dart';
import '../../providers/auth_providers.dart';
import '../../providers/order_providers.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/forms/brand_text_field.dart';

class CheckoutPage extends HookConsumerWidget {
  const CheckoutPage({super.key, required this.package});

  final Package package;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final checkout = ref.watch(checkoutControllerProvider);
    final emailCtrl = useTextEditingController(
      text: auth.user?.email ?? '',
    );

    // When payment session is ready, navigate to confirmation.
    ref.listen<CheckoutState>(checkoutControllerProvider, (prev, next) {
      if (next.order != null && next.session != null && !next.isLoading) {
        // Fire-and-forget receipt email.
        ref.read(checkoutControllerProvider.notifier).sendReceipt();
        // Invalidate orders + sims lists so new purchases appear.
        ref.invalidate(ordersProvider);
        context.pushReplacement(
          RouteNames.orderConfirmation,
          extra: {
            'order': next.order,
            'session': next.session,
            'package': package,
          },
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            _OrderSummary(package: package),
            const SizedBox(height: AppSpacing.lg),
            const _SectionTitle('Delivery email'),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'We will email the eSIM QR code + installation instructions to this address.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            BrandTextField(
              controller: emailCtrl,
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              icon: Icons.mail_outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            _PaymentModeCard(),
            if (checkout.error != null) ...[
              const SizedBox(height: AppSpacing.md),
              _ErrorBanner(message: checkout.error!),
            ],
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Place order • ${package.priceDisplay}',
              isLoading: checkout.isLoading,
              onPressed: checkout.isLoading
                  ? null
                  : () {
                      final email = emailCtrl.text.trim();
                      if (email.isEmpty || !email.contains('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid email.'),
                          ),
                        );
                        return;
                      }
                      ref
                          .read(checkoutControllerProvider.notifier)
                          .startCheckout(
                            packageCode: package.packageCode,
                            email: email,
                          );
                    },
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'By placing this order you agree to the EvairSIM Terms of Service.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: AppColors.textWeak),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.package});
  final Package package;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${package.locationName} • ${package.volumeDisplay} • ${package.durationDisplay}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const Divider(height: AppSpacing.xl * 1.5, color: AppColors.borderDefault),
          _SummaryRow(label: 'Subtotal', value: package.priceDisplay),
          const SizedBox(height: 6),
          const _SummaryRow(label: 'Taxes & fees', value: 'Included'),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                package.priceDisplay,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _PaymentModeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: AppColors.info),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Test mode — payment will be simulated. A real Stripe checkout will be added before TestFlight release.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.info,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(AppRadius.r12),
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
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
