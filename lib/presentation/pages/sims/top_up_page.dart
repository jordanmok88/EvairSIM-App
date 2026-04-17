import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/recharge_package.dart';
import '../../providers/sim_providers.dart';
import '../../widgets/buttons/primary_button.dart';

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
    final async = ref.watch(rechargePackagesProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Top up'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              e.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'No top-up packages available for this SIM.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return Column(
            children: [
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
                      selected: _selectedCode == p.packageCode,
                      onTap: () =>
                          setState(() => _selectedCode = p.packageCode),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                child: Column(
                  children: [
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    PrimaryButton(
                      label: 'Confirm top up',
                      isLoading: _submitting,
                      onPressed: _selectedCode == null || _submitting
                          ? null
                          : () => _submit(list),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submit(List<RechargePackage> list) async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(simRepositoryProvider);
    final res = await repo.createTopUpOrder(
      iccid: widget.iccid,
      packageCode: _selectedCode!,
    );
    if (!mounted) return;
    res.match(
      (l) => setState(() {
        _submitting = false;
        _error = l.message;
      }),
      (order) {
        ref.invalidate(userSimsProvider);
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Top-up order placed: ${order.orderNo}')),
        );
        context.pop();
      },
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
