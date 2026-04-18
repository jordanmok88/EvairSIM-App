import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/recharge_order.dart';
import '../../providers/sim_providers.dart';

/// Top-up history, sourced from `/v1/app/recharge-records` (admin portal).
///
/// After the April 2026 pivot the app no longer sells eSIMs, so this screen
/// is dedicated to recharge orders only.  Legacy `AppOrder` marketplace
/// history has been intentionally removed.
class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(rechargeRecordsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Top-up history'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(rechargeRecordsProvider),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const _EmptyView();
          }
          return RefreshIndicator(
            color: AppColors.brandOrange,
            onRefresh: () async {
              ref.invalidate(rechargeRecordsProvider);
              await ref.read(rechargeRecordsProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              itemCount: orders.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) => _RechargeTile(order: orders[i]),
            ),
          );
        },
      ),
    );
  }
}

class _RechargeTile extends StatelessWidget {
  const _RechargeTile({required this.order});
  final RechargeOrder order;

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt == null
        ? ''
        : DateFormat.yMMMd().add_jm().format(order.createdAt!.toLocal());

    final (statusLabel, statusColor) = _statusVisuals(order);
    final supplier = switch ((order.supplierType ?? '').toLowerCase()) {
      'esimaccess' => 'eSIM',
      'pccw' => 'SIM Card',
      _ => 'SIM',
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.orderNo ?? '#${order.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            order.planName ?? 'Top-up',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$supplier • ICCID ${order.iccid ?? '—'}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                '${order.amountDisplay} ${order.currency}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandOrange,
                ),
              ),
            ],
          ),
          if ((order.failureReason ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: Text(
                order.failureReason!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  (String, Color) _statusVisuals(RechargeOrder o) {
    if (o.isFailed) return ('FAILED', AppColors.error);
    if (o.isPaid) return ('PAID', AppColors.success);
    if (o.isPending) return ('PENDING', AppColors.warning);
    final status = (o.orderStatus ?? o.paymentStatus ?? 'UNKNOWN').toUpperCase();
    return (status, AppColors.textSecondary);
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 48, color: AppColors.textWeak),
            SizedBox(height: AppSpacing.md),
            Text(
              'No top-ups yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Top-ups appear here after you recharge a SIM from My SIMs.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 40, color: AppColors.textWeak),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
