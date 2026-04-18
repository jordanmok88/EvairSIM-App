import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/sim.dart';
import '../../providers/sim_providers.dart';
import '../../providers/sim_type_provider.dart';
import '../../widgets/sims/sim_card_tile.dart';
import '../../widgets/sims/usage_donut.dart';

/// My SIMs tab — H5-faithful layout:
///  • Sticky header with SIM Card / eSIM segmented toggle + "+ Activate" CTA
///  • Usage donut showing aggregate data for the filtered SIMs
///  • Install banner (eSIM-only) for any SIM still in RELEASED/NEW state
///  • SIM list using the branded SimCardTile
class MySimsPage extends ConsumerWidget {
  const MySimsPage({super.key, this.embedded = false});

  /// When true, renders only the body (no Scaffold, SafeArea, or internal
  /// header) so it can be composed inside [HomeShell]. Standalone mode
  /// keeps the legacy header for deep-link usage.
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sims = ref.watch(userSimsProvider);
    final simType = ref.watch(simTypeControllerProvider);

    final body = sims.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorBlock(message: e.toString()),
      data: (all) {
        final filtered = _filter(all, simType);
        if (all.isEmpty) return _EmptyState(simType: simType);
        if (filtered.isEmpty) return _EmptyForType(simType: simType);
        return RefreshIndicator(
          color: AppColors.brandOrange,
          onRefresh: () async {
            ref.invalidate(userSimsProvider);
            await ref.read(userSimsProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            children: [
              _UsageOverview(sims: filtered),
              const SizedBox(height: AppSpacing.md),
              if (simType == SimType.esim) _InstallBanner(sims: filtered),
              const SizedBox(height: AppSpacing.sm),
              ...filtered.expand((sim) => [
                    SimCardTile(
                      sim: sim,
                      onTap: () => _openSim(context, sim.iccid),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ]),
            ],
          ),
        );
      },
    );

    if (embedded) return body;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              simType: simType,
              onChangeType: (t) =>
                  ref.read(simTypeControllerProvider.notifier).set(t),
              onAdd: () => _handleAdd(context, simType),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  List<Sim> _filter(List<Sim> all, SimType type) {
    return all.where((s) {
      final isEsim = s.isEsim;
      return type == SimType.esim ? isEsim : !isEsim;
    }).toList(growable: false);
  }

  void _handleAdd(BuildContext context, SimType type) {
    if (type == SimType.esim) {
      context.push(RouteNames.connectEsim);
    } else {
      context.push(RouteNames.physicalSim);
    }
  }
}

void _openSim(BuildContext context, String iccid) {
  context.push('${RouteNames.mySims}/$iccid');
}

class _Header extends StatelessWidget {
  const _Header({
    required this.simType,
    required this.onChangeType,
    required this.onAdd,
  });
  final SimType simType;
  final ValueChanged<SimType> onChangeType;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border:
            Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'My SIMs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              _AddButton(
                label: simType == SimType.esim ? 'Connect' : 'Activate',
                icon: simType == SimType.esim
                    ? Icons.sim_card_download_outlined
                    : Icons.qr_code_scanner,
                onPressed: onAdd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SimTypeSegmented(value: simType, onChanged: onChangeType),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brandOrange,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimTypeSegmented extends StatelessWidget {
  const _SimTypeSegmented({required this.value, required this.onChanged});
  final SimType value;
  final ValueChanged<SimType> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final half = (constraints.maxWidth - 8) / 2;
        final isPhysical = value == SimType.physical;
        return Container(
          height: 40,
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
                left: isPhysical ? 0 : half,
                top: 0,
                bottom: 0,
                width: half,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange,
                    borderRadius: BorderRadius.circular(AppRadius.r10),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _SegBtn(
                      icon: Icons.credit_card,
                      label: 'SIM Card',
                      selected: isPhysical,
                      onTap: () => onChanged(SimType.physical),
                    ),
                  ),
                  Expanded(
                    child: _SegBtn(
                      icon: Icons.smartphone,
                      label: 'eSIM',
                      selected: !isPhysical,
                      onTap: () => onChanged(SimType.esim),
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

class _SegBtn extends StatelessWidget {
  const _SegBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.white : AppColors.textSecondary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r10),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsageOverview extends StatelessWidget {
  const _UsageOverview({required this.sims});
  final List<Sim> sims;

  @override
  Widget build(BuildContext context) {
    var total = 0;
    var used = 0;
    for (final s in sims) {
      total += s.totalBytes ?? 0;
      used += s.usedBytes ?? 0;
    }
    final pct = total == 0 ? 0.0 : used / total;
    final pctLabel = total == 0 ? '—' : '${(pct * 100).round()}%';
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
                  'TOTAL USAGE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_fmt(used)} / ${_fmt(total)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${sims.length} ${sims.length == 1 ? 'SIM' : 'SIMs'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
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
    if (bytes >= gb) {
      final v = bytes / gb;
      return v == v.roundToDouble()
          ? '${v.toInt()} GB'
          : '${v.toStringAsFixed(1)} GB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  }
}

class _InstallBanner extends StatelessWidget {
  const _InstallBanner({required this.sims});
  final List<Sim> sims;

  @override
  Widget build(BuildContext context) {
    final uninstalled =
        sims.where((s) => s.isEsim && !s.isInstalled).toList(growable: false);
    if (uninstalled.isEmpty) return const SizedBox.shrink();

    return Material(
      color: const Color(0xFFEFF6FF),
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        onTap: () => _showInstallSheet(context, uninstalled.first),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
                child: const Icon(Icons.sim_card_download,
                    color: Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${uninstalled.length} eSIM${uninstalled.length == 1 ? '' : 's'} waiting to install',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Tap to install — one-time only (GSMA spec)',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF3B82F6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF3B82F6)),
            ],
          ),
        ),
      ),
    );
  }
}

void _showInstallSheet(BuildContext context, Sim sim) {
  final qrData = (sim.lpaCode != null && sim.lpaCode!.isNotEmpty)
      ? sim.lpaCode!
      : (sim.qrcode ?? '');
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (ctx) => _InstallSheet(sim: sim, qrData: qrData),
  );
}

class _InstallSheet extends StatelessWidget {
  const _InstallSheet({required this.sim, required this.qrData});
  final Sim sim;
  final String qrData;

  @override
  Widget build(BuildContext context) {
    final hasPayload = qrData.isNotEmpty;
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.pageHorizontal,
        right: AppSpacing.pageHorizontal,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r20),
          topRight: Radius.circular(AppRadius.r20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Install your eSIM',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'One-time install — re-downloads are not supported by the network.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (hasPayload)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.r16),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: QrImageView(
                data: qrData,
                size: 220,
                backgroundColor: AppColors.white,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.r16),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: const Text(
                'Activation code is still being provisioned by the supplier.\nCheck back in a minute.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          _InfoBlock(label: 'ICCID', value: sim.iccid),
          if ((sim.smdpAddress ?? '').isNotEmpty)
            _InfoBlock(label: 'SM-DP+', value: sim.smdpAddress!),
          if ((sim.acCode ?? '').isNotEmpty)
            _InfoBlock(label: 'Activation code', value: sim.acCode!),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textWeak,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Courier',
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.simType});
  final SimType simType;

  @override
  Widget build(BuildContext context) {
    final isEsim = simType == SimType.esim;
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
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEsim
                  ? 'Connect an eSIM by pasting its LPA / QR code.'
                  : 'Activate your EvairSIM card by scanning the barcode or entering the ICCID.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonalIcon(
              onPressed: () => context.push(
                isEsim ? RouteNames.connectEsim : RouteNames.physicalSim,
              ),
              icon: Icon(
                isEsim
                    ? Icons.sim_card_download_outlined
                    : Icons.qr_code_scanner,
                size: 18,
              ),
              label: Text(
                isEsim ? 'Connect eSIM' : 'Activate SIM',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyForType extends StatelessWidget {
  const _EmptyForType({required this.simType});
  final SimType simType;

  @override
  Widget build(BuildContext context) {
    final isEsim = simType == SimType.esim;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEsim ? Icons.smartphone : Icons.credit_card,
              size: 48,
              color: AppColors.textWeak,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              isEsim ? 'No eSIMs yet' : 'No physical SIMs yet',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEsim
                  ? 'Tap "Connect" to add an eSIM.'
                  : 'Tap "Activate" to bind your EvairSIM card.',
              textAlign: TextAlign.center,
              style: const TextStyle(
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
