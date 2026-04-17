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
import '../../widgets/sims/sim_card_tile.dart';
import '../../widgets/sims/usage_donut.dart';

class MySimsPage extends ConsumerWidget {
  const MySimsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sims = ref.watch(userSimsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.md,
                AppSpacing.pageHorizontal,
                AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My SIMs',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner,
                        color: AppColors.textPrimary),
                    tooltip: 'Activate physical SIM',
                    onPressed: () => context.push(RouteNames.physicalSim),
                  ),
                ],
              ),
            ),
            Expanded(
              child: sims.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => _ErrorBlock(message: e.toString()),
                data: (list) {
                  if (list.isEmpty) return const _EmptyState();
                  return RefreshIndicator(
                    color: AppColors.brandOrange,
                    onRefresh: () async {
                      ref.invalidate(userSimsProvider);
                      await ref.read(userSimsProvider.future);
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
                      children: [
                        _UsageOverview(sims: list),
                        const SizedBox(height: AppSpacing.lg),
                        ...list.expand((sim) => [
                              SimCardTile(
                                sim: sim,
                                onTap: () =>
                                    _openSim(context, sim.iccid),
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ]),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openSim(BuildContext context, String iccid) {
  context.push('${RouteNames.mySims}/$iccid');
}

class _UsageOverview extends StatelessWidget {
  const _UsageOverview({required this.sims});
  final List<Sim> sims;

  @override
  Widget build(BuildContext context) {
    // Aggregate active-SIM usage.
    int total = 0;
    int used = 0;
    for (final s in sims) {
      total += s.totalBytes ?? 0;
      used += s.usedBytes ?? 0;
    }
    final pct = total == 0 ? 0.0 : used / total;
    final pctLabel = '${(pct * 100).round()}%';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          UsageDonut(
            percent: pct,
            centerTop: pctLabel,
            centerBottom: 'Used',
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total data usage',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_fmt(used)} / ${_fmt(total)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${sims.length} SIM${sims.length == 1 ? '' : 's'} active',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int bytes) {
    if (bytes <= 0) return '0 MB';
    const gb = 1024 * 1024 * 1024;
    if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(1)} GB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sim_card_outlined,
                size: 56, color: AppColors.textWeak),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'No SIMs yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Buy an eSIM or bind a physical SIM to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonal(
              onPressed: () => context.go(RouteNames.shop),
              child: const Text('Browse eSIM plans'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: () => context.push(RouteNames.physicalSim),
              icon: const Icon(Icons.qr_code_scanner, size: 18),
              label: const Text('Activate a physical SIM'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.message});
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
