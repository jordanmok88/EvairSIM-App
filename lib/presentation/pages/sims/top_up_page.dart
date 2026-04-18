import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/recharge_package.dart';
import '../../../domain/entities/sim.dart';
import '../../providers/sim_providers.dart';
import '../../widgets/buttons/primary_button.dart';

/// Top-up flow — admin-portal-managed recharge packages.
///
/// Flow:
///   1. Load SIM from the user's bound list (for supplier type).
///   2. Fetch packages filtered by `supplier_type` (`pccw` / `esimaccess`).
///   3. On confirm: POST /v1/app/recharge → create recharge record.
///   4. POST /v1/app/recharge/{id}/pay → Stripe PaymentIntent.
///   5. Show success + PaymentIntent id (full Stripe sheet is a later
///      milestone once the publishable key is wired).
class TopUpPage extends ConsumerStatefulWidget {
  const TopUpPage({super.key, required this.iccid});
  final String iccid;

  @override
  ConsumerState<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends ConsumerState<TopUpPage> {
  String? _selectedCode;
  bool _submitting = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final simsAsync = ref.watch(userSimsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Top up'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: simsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (sims) {
          final sim = sims.firstWhere(
            (s) => s.iccid == widget.iccid,
            orElse: () => Sim(iccid: widget.iccid),
          );
          final supplierType = supplierTypeForSim(sim);
          return _Body(
            sim: sim,
            supplierType: supplierType,
            selectedCode: _selectedCode,
            onSelect: (code) => setState(() => _selectedCode = code),
            error: _error,
            submitting: _submitting,
            onConfirm: (pkg) => _submit(sim, pkg),
          );
        },
      ),
    );
  }

  Future<void> _submit(Sim sim, RechargePackage pkg) async {
    setState(() {
      _submitting = true;
      _error = null;
    });

    final repo = ref.read(simRepositoryProvider);
    final orderRes = await repo.createRechargeOrder(
      iccid: widget.iccid,
      supplierType: pkg.supplierType,
      packageCode: pkg.packageCode,
    );

    if (!mounted) return;

    await orderRes.match(
      (failure) async {
        setState(() {
          _submitting = false;
          _error = failure.message;
        });
      },
      (order) async {
        // Request Stripe PaymentIntent. Full card sheet lands once the
        // publishable key is configured; for now we surface the intent ID.
        final payRes = await repo.payRecharge(rechargeId: order.id);
        if (!mounted) return;
        payRes.match(
          (failure) => setState(() {
            _submitting = false;
            _error =
                'Order ${order.orderNo ?? order.id} created, but payment setup failed: ${failure.message}';
          }),
          (intent) {
            ref.invalidate(userSimsProvider);
            ref.invalidate(rechargeRecordsProvider);
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Order ${order.orderNo ?? 'created'} — '
                  'payment intent ${intent.paymentIntentId ?? 'ready'}',
                ),
              ),
            );
            context.pop();
          },
        );
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.sim,
    required this.supplierType,
    required this.selectedCode,
    required this.onSelect,
    required this.error,
    required this.submitting,
    required this.onConfirm,
  });

  final Sim sim;
  final String supplierType;
  final String? selectedCode;
  final ValueChanged<String> onSelect;
  final String? error;
  final bool submitting;
  final ValueChanged<RechargePackage> onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync =
        ref.watch(rechargePackagesProvider(supplierType));

    return packagesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(message: e.toString()),
      data: (list) {
        if (list.isEmpty) {
          return _EmptyView(supplierType: supplierType);
        }
        final selected = list.firstWhere(
          (p) => p.packageCode == selectedCode,
          orElse: () => list.first,
        );
        return Column(
          children: [
            _SimSummary(sim: sim, supplierType: supplierType),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final p = list[i];
                  return _RechargeTile(
                    package: p,
                    selected: selectedCode == p.packageCode,
                    onTap: () => onSelect(p.packageCode),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              child: Column(
                children: [
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        error!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  PrimaryButton(
                    label: selectedCode == null
                        ? 'Select a plan to continue'
                        : 'Pay ${selected.priceDisplay}',
                    isLoading: submitting,
                    onPressed: selectedCode == null || submitting
                        ? null
                        : () => onConfirm(selected),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SimSummary extends StatelessWidget {
  const _SimSummary({required this.sim, required this.supplierType});
  final Sim sim;
  final String supplierType;

  @override
  Widget build(BuildContext context) {
    final label = supplierType == 'esimaccess'
        ? 'EvairSIM eSIM'
        : 'EvairSIM card';
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        0,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandOrange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
            child: const Icon(Icons.sim_card,
                color: AppColors.brandOrange, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ICCID: ${sim.iccid}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RechargeTile extends StatelessWidget {
  const _RechargeTile({
    required this.package,
    required this.selected,
    required this.onTap,
  });
  final RechargePackage package;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(
              color:
                  selected ? AppColors.brandOrange : AppColors.borderDefault,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected ? AppShadows.sm : null,
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.brandOrange
                        : AppColors.borderDefault,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Center(
                        child: Icon(Icons.circle,
                            size: 10, color: AppColors.brandOrange))
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${package.volumeDisplay} • ${package.durationDisplay}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                package.priceDisplay,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.error),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.supplierType});
  final String supplierType;

  @override
  Widget build(BuildContext context) {
    final which = supplierType == 'esimaccess'
        ? 'EvairSIM eSIM'
        : 'EvairSIM card';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined,
                size: 48, color: AppColors.textWeak),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No top-up plans available for $which right now.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Plans are configured in the admin portal → 充值套餐管理.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textWeak,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
