import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/i18n/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/entities/package.dart';
import '../../providers/shop_providers.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/shop/package_card.dart';

class CountryPackagesPage extends ConsumerWidget {
  const CountryPackagesPage({
    super.key,
    required this.countryCode,
    this.country,
  });

  final String countryCode;
  final Country? country;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync =
        ref.watch(packagesByCountryProvider(countryCode.toUpperCase()));
    final title = country?.name ?? countryCode.toUpperCase();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              title: title,
              code: countryCode.toUpperCase(),
              onBack: () => context.pop(),
            ),
            Expanded(
              child: packagesAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => _ErrorBlock(message: e.toString()),
                data: (packages) {
                  if (packages.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: Text(
                          'No plans are available for this country yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.brandOrange,
                    onRefresh: () async {
                      ref.invalidate(packagesByCountryProvider(
                          countryCode.toUpperCase()));
                      await ref.read(packagesByCountryProvider(
                              countryCode.toUpperCase())
                          .future);
                    },
                    child: ListView.separated(
                      padding:
                          const EdgeInsets.all(AppSpacing.pageHorizontal),
                      itemCount: packages.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, i) => PackageCard(
                        package: packages[i],
                        highlightBest: i == 0,
                        onTap: () =>
                            _showPackagePreview(context, packages[i]),
                      ),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.code,
    required this.onBack,
  });
  final String title;
  final String code;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.pageHorizontal,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: onBack,
          ),
          Text(
            _toFlag(code),
            style: const TextStyle(fontSize: 26),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'Available eSIM plans',
                  style: TextStyle(
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

  static String _toFlag(String code) {
    if (code.length != 2) return '🏳️';
    const base = 0x1F1E6;
    final upper = code.toUpperCase();
    return String.fromCharCodes([
      base + (upper.codeUnitAt(0) - 0x41),
      base + (upper.codeUnitAt(1) - 0x41),
    ]);
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
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.errorBg,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.errorBorder),
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off,
                  color: AppColors.error, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showPackagePreview(BuildContext context, Package package) {
  showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    backgroundColor: AppColors.cardBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: AppRadius.bottomSheet,
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            package.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${package.locationName} • ${package.volumeDisplay} • ${package.durationDisplay}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                package.priceDisplay,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandOrange,
                  height: 1,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  package.currency,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _FeatureBadge(
                icon: Icons.speed,
                label: package.speed,
              ),
              _FeatureBadge(
                icon: Icons.category,
                label: package.type,
              ),
              ...package.features.map((f) =>
                  _FeatureBadge(icon: Icons.check_circle_outline, label: f)),
            ],
          ),
          if ((package.description ?? '').isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              package.description!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label:
                '${AppStrings.of(context).shopBuyNow} • ${package.priceDisplay}',
            icon: Icons.shopping_bag,
            onPressed: () {
              Navigator.of(context).pop();
              context.push(RouteNames.checkout, extra: package);
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    ),
  );
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.fillLight,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
