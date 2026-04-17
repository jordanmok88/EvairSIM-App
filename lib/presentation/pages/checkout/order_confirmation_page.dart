import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/package.dart';
import '../../../domain/entities/payment_session.dart';
import '../../widgets/buttons/primary_button.dart';

/// Shown after a successful checkout. Displays:
///  * A celebratory header
///  * Order summary + total paid
///  * A QR code derived from the payment intent ID (placeholder until the
///    backend issues a real LPA string on eSIM provisioning)
///  * Email-receipt status + primary CTA back to shop / my SIMs.
class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({
    super.key,
    required this.order,
    required this.session,
    required this.package,
  });

  final AppOrder order;
  final PaymentSession session;
  final Package package;

  @override
  Widget build(BuildContext context) {
    // Prefer the real activation string once the backend has provisioned the
    // eSIM. Otherwise fall back to an order-reference payload so the page can
    // still be exercised end-to-end in dev / test mode.
    final provisionedLpa = order.lpaCode;
    final qrPayload = (provisionedLpa != null && provisionedLpa.isNotEmpty)
        ? provisionedLpa
        : 'LPA:1\$evair.zhhwxt.cn\$${order.orderNo}';
    final isRealLpa = provisionedLpa != null && provisionedLpa.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Container(
                width: 64,
                height: 64,
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.successBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 36,
                  color: AppColors.successDeep,
                ),
              ),
              const Text(
                'Order placed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'We emailed the QR code + activation instructions. '
                'You can also scan it below on another device.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _QrCard(payload: qrPayload, isReal: isRealLpa),
              const SizedBox(height: AppSpacing.lg),
              _OrderDetails(order: order, package: package, session: session),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Go to My SIMs',
                icon: Icons.sim_card,
                onPressed: () => context.go(RouteNames.mySims),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.go(RouteNames.shop),
                child: const Text(
                  'Keep shopping',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrCard extends StatelessWidget {
  const _QrCard({required this.payload, required this.isReal});
  final String payload;
  final bool isReal;

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
        children: [
          const Text(
            'eSIM activation',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.r16),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: QrImageView(
              data: payload,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: AppColors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.textPrimary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (!isReal)
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: const Text(
                'Provisioning… the real activation QR will appear here once the eSIM is issued.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline,
                  color: AppColors.textWeak, size: 14),
              const SizedBox(width: 4),
              const Text(
                'One-time activation',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textWeak,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.copy,
                    color: AppColors.textSecondary, size: 16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: payload));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('LPA string copied'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderDetails extends StatelessWidget {
  const _OrderDetails({
    required this.order,
    required this.package,
    required this.session,
  });
  final AppOrder order;
  final Package package;
  final PaymentSession session;

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
        children: [
          _Row(label: 'Order #', value: order.orderNo),
          _Row(label: 'Plan', value: package.name),
          _Row(
            label: 'Data',
            value:
                '${package.volumeDisplay} • ${package.durationDisplay}',
          ),
          _Row(label: 'Total paid', value: package.priceDisplay),
          _Row(
            label: 'Payment',
            value: session.paymentIntentId,
            mono: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.mono = false});
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                fontFamily: mono ? 'Courier' : null,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
