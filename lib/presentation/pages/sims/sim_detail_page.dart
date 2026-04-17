import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/sim.dart';
import '../../providers/sim_providers.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/sims/usage_donut.dart';

class SimDetailPage extends ConsumerWidget {
  const SimDetailPage({super.key, required this.iccid});
  final String iccid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simAsync = ref.watch(simDetailProvider(iccid));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SIM detail'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: simAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(e.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error)),
          ),
        ),
        data: (sim) => _Body(sim: sim),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.sim});
  final Sim sim;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: AppRadius.card,
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              children: [
                UsageDonut(
                  percent: sim.usagePercent ?? 0,
                  centerTop: sim.usagePercent == null
                      ? '—'
                      : '${((sim.usagePercent ?? 0) * 100).round()}%',
                  centerBottom: 'Used',
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  sim.packageName ?? 'Unnamed plan',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  sim.iccid,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Courier',
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoRow(label: 'Status', value: sim.status ?? 'UNKNOWN'),
          _InfoRow(label: 'Type', value: sim.type ?? 'UNKNOWN'),
          _InfoRow(
              label: 'Remaining', value: sim.remainingDisplay),
          _InfoRow(label: 'Total', value: sim.totalDisplay),
          _InfoRow(
            label: 'Expires',
            value: sim.expiresAt == null
                ? '—'
                : '${sim.expiresAt!.toLocal()}'.split(' ').first,
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Top up data',
            icon: Icons.add_circle_outline,
            onPressed: () =>
                context.push('${RouteNames.mySims}/${sim.iccid}/topup'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
