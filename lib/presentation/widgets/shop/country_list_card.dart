import 'package:flutter/material.dart';

import '../../../core/constants/popular_countries.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/country.dart';

/// H5-style single white card with internal dividers. Popular rows get an
/// amber tint + star. Optionally shows an "All countries" section separator
/// before the first non-popular row (mirrors `shop.all_countries_separator`
/// in the H5).
class CountryListCard extends StatelessWidget {
  const CountryListCard({
    super.key,
    required this.countries,
    required this.onTap,
    this.showSeparatorAfterPopular = true,
  });

  final List<Country> countries;
  final ValueChanged<Country> onTap;
  final bool showSeparatorAfterPopular;

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    bool separatorInjected = false;

    for (var i = 0; i < countries.length; i++) {
      final country = countries[i];
      final isPopular = isPopularCountry(country.code);
      final isFirst = i == 0;
      final isLast = i == countries.length - 1;

      if (showSeparatorAfterPopular &&
          !separatorInjected &&
          !isPopular &&
          !isFirst) {
        rows.add(const _SectionSeparator());
        separatorInjected = true;
      }

      rows.add(_CountryRow(
        country: country,
        isPopular: isPopular,
        isFirst: isFirst,
        isLast: isLast,
        onTap: () => onTap(country),
      ));

      if (!isLast) {
        rows.add(const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.borderDefault,
        ));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        boxShadow: AppShadows.subtle,
        border: Border.all(color: AppColors.borderDefault),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: rows),
    );
  }
}

class _CountryRow extends StatelessWidget {
  const _CountryRow({
    required this.country,
    required this.isPopular,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final Country country;
  final bool isPopular;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPopular ? AppColors.popularRowBg : AppColors.cardBackground,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md - 2,
          ),
          child: Row(
            children: [
              _FlagBadge(code: country.code),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
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
                        if (isPopular) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: AppColors.starAmber,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'View plans',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textWeak,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textWeak,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  const _FlagBadge({required this.code});
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

class _SectionSeparator extends StatelessWidget {
  const _SectionSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      color: AppColors.fillLight,
      child: const Text(
        'ALL COUNTRIES',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: AppColors.textWeak,
        ),
      ),
    );
  }
}
