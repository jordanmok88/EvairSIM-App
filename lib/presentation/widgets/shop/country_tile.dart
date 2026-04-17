import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/country.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({
    super.key,
    required this.country,
    required this.onTap,
  });

  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            boxShadow: AppShadows.subtle,
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            children: [
              _FlagEmoji(code: country.code),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  country.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textWeak,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlagEmoji extends StatelessWidget {
  const _FlagEmoji({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.fillLight,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Text(
        _toFlagEmoji(code),
        style: const TextStyle(fontSize: 22),
      ),
    );
  }

  static String _toFlagEmoji(String code) {
    if (code.length != 2) return '🏳️';
    const base = 0x1F1E6;
    final upper = code.toUpperCase();
    final a = upper.codeUnitAt(0);
    final b = upper.codeUnitAt(1);
    if (a < 0x41 || a > 0x5A || b < 0x41 || b > 0x5A) return '🏳️';
    return String.fromCharCodes([base + (a - 0x41), base + (b - 0x41)]);
  }
}
