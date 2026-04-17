import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/sim.dart';

class SimCardTile extends StatelessWidget {
  const SimCardTile({super.key, required this.sim, this.onTap});
  final Sim sim;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEsim = sim.isEsim;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: isEsim ? AppGradients.heroDark : null,
            color: isEsim ? null : AppColors.cardBackground,
            borderRadius: AppRadius.card,
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isEsim
                          ? AppColors.white.withValues(alpha: 0.18)
                          : AppColors.brandOrange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                    ),
                    child: Text(
                      isEsim ? 'eSIM' : 'SIM CARD',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isEsim
                            ? AppColors.white
                            : AppColors.brandOrange,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _StatusChip(status: sim.status, isEsim: isEsim),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                sim.packageName ?? 'Unnamed plan',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isEsim ? AppColors.white : AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sim.iccid,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Courier',
                  color: isEsim
                      ? AppColors.white.withValues(alpha: 0.8)
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _MetricPill(
                    label: 'Left',
                    value: sim.remainingDisplay,
                    onDark: isEsim,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _MetricPill(
                    label: 'Expires',
                    value: sim.daysLeft == null
                        ? '—'
                        : (sim.daysLeft! < 0
                            ? 'Expired'
                            : 'in ${sim.daysLeft}d'),
                    onDark: isEsim,
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.isEsim});
  final String? status;
  final bool isEsim;

  @override
  Widget build(BuildContext context) {
    final s = (status ?? 'UNKNOWN').toUpperCase();
    final color = switch (s) {
      'ENABLED' || 'IN_USE' || 'ACTIVE' => AppColors.success,
      'DISABLED' || 'EXPIRED' => AppColors.textMuted,
      _ => AppColors.brandOrange,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isEsim ? 0.9 : 0.12),
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Text(
        s,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: isEsim ? AppColors.white : color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.onDark,
  });
  final String label;
  final String value;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: onDark
              ? AppColors.white.withValues(alpha: 0.1)
              : AppColors.fillLight,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: onDark
                    ? AppColors.white.withValues(alpha: 0.7)
                    : AppColors.textWeak,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: onDark ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
