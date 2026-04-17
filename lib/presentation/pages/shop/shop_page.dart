import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/i18n/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/entities/package.dart';
import '../../providers/auth_providers.dart';
import '../../providers/shop_providers.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/shop/country_tile.dart';
import '../../widgets/shop/package_card.dart';

/// Milestone 2 — browse-only shop.
class ShopPage extends HookConsumerWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = useState('');
    final countriesAsync = ref.watch(countriesProvider);
    final hotPackagesAsync = ref.watch(hotPackagesProvider);
    final user = ref.watch(authControllerProvider).user;
    final strings = AppStrings.of(context);

    Future<void> refresh() async {
      ref.invalidate(countriesProvider);
      ref.invalidate(hotPackagesProvider);
      await Future.wait([
        ref.read(countriesProvider.future),
        ref.read(hotPackagesProvider.future),
      ]);
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.brandOrange,
          onRefresh: refresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _Header(
                  greeting: strings.shopGreetingUser(
                      user?.name ?? user?.email ?? 'there'),
                  onLogout: () async {
                    await ref
                        .read(authControllerProvider.notifier)
                        .logout();
                    if (!context.mounted) return;
                    context.go(RouteNames.login);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: _SearchBar(
                  hint: strings.shopSearchHint,
                  onChanged: (v) => search.value = v.trim().toLowerCase(),
                ),
              ),
              SliverToBoxAdapter(
                child: _SectionTitle(title: strings.shopPopular),
              ),
              _HotPackages(async: hotPackagesAsync),
              SliverToBoxAdapter(
                child: _SectionTitle(title: strings.shopBrowseByCountry),
              ),
              _CountryList(async: countriesAsync, query: search.value),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.greeting, required this.onLogout});
  final String greeting;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        gradient: AppGradients.heroDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r32),
          bottomRight: Radius.circular(AppRadius.r32),
        ),
        boxShadow: AppShadows.brandCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EvairSIM',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      greeting,
                      style: const TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, color: AppColors.white),
                tooltip: 'Log out',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            '207 countries • 2,489+ plans',
            style: TextStyle(
              color: Color(0xE6FFFFFF),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onChanged});
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.lg,
        AppSpacing.pageHorizontal,
        0,
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: AppColors.textWeak, fontSize: 14),
          filled: true,
          fillColor: AppColors.cardBackground,
          prefixIcon: const Icon(Icons.search,
              size: 20, color: AppColors.textSecondary),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: const BorderSide(color: AppColors.borderDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide: const BorderSide(color: AppColors.borderDefault),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            borderSide:
                const BorderSide(color: AppColors.brandOrange, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.xl,
        AppSpacing.pageHorizontal,
        AppSpacing.md,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _HotPackages extends StatelessWidget {
  const _HotPackages({required this.async});
  final AsyncValue<List<Package>> async;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => const SliverToBoxAdapter(
        child: _HotSkeleton(),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: _InlineError(message: e.toString()),
      ),
      data: (packages) {
        if (packages.isEmpty) {
          return const SliverToBoxAdapter(
              child: _EmptyState(label: 'No popular plans right now'));
        }
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
              ),
              itemCount: packages.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, i) {
                return SizedBox(
                  width: 220,
                  child: PackageCard(
                    package: packages[i],
                    highlightBest: i == 0,
                    onTap: () => _showPackagePreview(context, packages[i]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _CountryList extends StatelessWidget {
  const _CountryList({required this.async, required this.query});
  final AsyncValue<List<Country>> async;
  final String query;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => const SliverToBoxAdapter(child: _ListSkeleton()),
      error: (e, _) => SliverToBoxAdapter(
        child: _InlineError(message: e.toString()),
      ),
      data: (countries) {
        final filtered = query.isEmpty
            ? countries
            : countries
                .where((c) =>
                    c.name.toLowerCase().contains(query) ||
                    c.code.toLowerCase().contains(query))
                .toList();

        if (filtered.isEmpty) {
          return const SliverToBoxAdapter(
              child: _EmptyState(label: 'No countries match your search'));
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
          ),
          sliver: SliverList.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final country = filtered[i];
              return CountryTile(
                country: country,
                onTap: () => context.push(
                  '${RouteNames.countryPackages}/${country.code}',
                  extra: country,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _HotSkeleton extends StatelessWidget {
  const _HotSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, __) => Container(
          width: 220,
          decoration: BoxDecoration(
            color: AppColors.fillLight,
            borderRadius: BorderRadius.circular(AppRadius.r16),
          ),
        ),
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageHorizontal,
      ),
      child: Column(
        children: List.generate(
          6,
          (_) => Container(
            height: 60,
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.fillLight,
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.errorBg,
          borderRadius: BorderRadius.circular(AppRadius.r10),
          border: Border.all(color: AppColors.errorBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.error, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
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
          const SizedBox(height: AppSpacing.xl),
          Text(
            package.priceDisplay,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.brandOrange,
              letterSpacing: -1,
            ),
          ),
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
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    ),
  );
}
