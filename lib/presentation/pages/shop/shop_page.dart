import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/constants/popular_countries.dart';
import '../../../core/i18n/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/country.dart';
import '../../providers/auth_providers.dart';
import '../../providers/shop_providers.dart';
import '../../providers/sim_type_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/shop/country_list_card.dart';

/// Shop — mirrors H5 `views/ShopView.tsx` 1:1:
/// white sticky header (greeting + bell + avatar) → SIM/eSIM toggle →
/// hero card → country list (popular rows highlighted in amber).
class ShopPage extends HookConsumerWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = useState('');
    final searchCtrl = useTextEditingController();
    final countriesAsync = ref.watch(countriesProvider);
    final user = ref.watch(authControllerProvider).user;
    final simType = ref.watch(simTypeControllerProvider);
    final strings = AppStrings.of(context);

    Future<void> refresh() async {
      ref.invalidate(countriesProvider);
      await ref.read(countriesProvider.future);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.brandOrange,
          onRefresh: refresh,
          child: CustomScrollView(
            slivers: [
              _ShopHeader(
                userName: user?.name,
                userEmail: user?.email,
                simType: simType,
                onSimTypeChanged: (t) =>
                    ref.read(simTypeControllerProvider.notifier).set(t),
                onInboxTap: () => context.push(RouteNames.inbox),
                onAvatarTap: () => context.go(RouteNames.profile),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.md,
                  AppSpacing.pageHorizontal,
                  0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (search.value.isEmpty)
                      _HeroCard(
                        simType: simType,
                        onPhysicalSetup: () =>
                            context.push(RouteNames.physicalSim),
                      ),
                    if (search.value.isEmpty) const SizedBox(height: AppSpacing.md),

                    if (simType == SimType.esim) ...[
                      _SectionSearchBar(
                        controller: searchCtrl,
                        hint: strings.shopSearchHint,
                        onChanged: (v) =>
                            search.value = v.trim().toLowerCase(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SectionTitle(
                        title: search.value.isEmpty
                            ? strings.shopBrowseByCountry
                            : 'Search results',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ]),
                ),
              ),

              if (simType == SimType.esim)
                _EsimCountrySliver(
                  async: countriesAsync,
                  query: search.value,
                )
              else
                const _PhysicalSimSliver(),

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

// ─────────────────────────────────────────────────────────────────────
// Header: white sticky bar with greeting + bell + avatar + SIM/eSIM toggle.
// Mirrors the three-row header in the H5 shop.
// ─────────────────────────────────────────────────────────────────────

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({
    required this.userName,
    required this.userEmail,
    required this.simType,
    required this.onSimTypeChanged,
    required this.onInboxTap,
    required this.onAvatarTap,
  });

  final String? userName;
  final String? userEmail;
  final SimType simType;
  final ValueChanged<SimType> onSimTypeChanged;
  final VoidCallback onInboxTap;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      backgroundColor: AppColors.cardBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 72,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          color: AppColors.cardBackground,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            0,
            AppSpacing.pageHorizontal,
            AppSpacing.sm + 2,
          ),
          child: _SimTypeSegmented(
            value: simType,
            onChanged: onSimTypeChanged,
          ),
        ),
      ),
      title: _HeaderTitleRow(
        userName: userName,
        userEmail: userEmail,
        onInboxTap: onInboxTap,
        onAvatarTap: onAvatarTap,
      ),
      titleSpacing: AppSpacing.pageHorizontal,
      automaticallyImplyLeading: false,
      // Hair-line divider under the whole header so it reads like H5.
      shape: const Border(
        bottom: BorderSide(color: AppColors.borderDefault, width: 1),
      ),
    );
  }
}

class _HeaderTitleRow extends StatelessWidget {
  const _HeaderTitleRow({
    required this.userName,
    required this.userEmail,
    required this.onInboxTap,
    required this.onAvatarTap,
  });

  final String? userName;
  final String? userEmail;
  final VoidCallback onInboxTap;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final isGuest = userName == null && userEmail == null;
    final displayName = userName ?? userEmail ?? 'new friend';
    final initial = (userName?.isNotEmpty == true
            ? userName!.characters.first
            : (userEmail?.isNotEmpty == true
                ? userEmail!.characters.first
                : '?'))
        .toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isGuest ? 'Hello, new friend' : 'Hello, $displayName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              const Text(
                'Find the perfect plan for your trip',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textWeak,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _HeaderIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onInboxTap,
        ),
        const SizedBox(width: 8),
        _HeaderAvatar(initial: initial, onTap: onAvatarTap),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.fillLight,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.initial, required this.onTap});
  final String initial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brandOrange, AppColors.brandOrangeLight],
            ),
          ),
          child: Text(
            initial,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// SIM Card / eSIM segmented toggle — animated orange pill slides under
// the selected side, matching H5 `bg-slate-100 rounded-xl` segmented.
// ─────────────────────────────────────────────────────────────────────

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
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.fillLight,
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOut,
                left: isPhysical ? 0 : half,
                top: 0,
                bottom: 0,
                width: half,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.brandOrange,
                    borderRadius: BorderRadius.circular(AppRadius.r10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33FF6600),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _SegmentButton(
                      icon: Icons.credit_card,
                      label: 'SIM Card',
                      selected: isPhysical,
                      onTap: () => onChanged(SimType.physical),
                    ),
                  ),
                  Expanded(
                    child: _SegmentButton(
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

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
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
    final color =
        selected ? AppColors.white : AppColors.textSecondary;
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Hero card: orange→red for eSIM, dark slate for physical SIM.
// ─────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.simType,
    required this.onPhysicalSetup,
  });
  final SimType simType;
  final VoidCallback onPhysicalSetup;

  @override
  Widget build(BuildContext context) {
    if (simType == SimType.esim) return const _EsimHero();
    return _PhysicalHero(onSetup: onPhysicalSetup);
  }
}

class _EsimHero extends StatelessWidget {
  const _EsimHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brandOrange, AppColors.brandRed],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26CC0000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Evair',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextSpan(
                      text: 'SIM',
                      style: TextStyle(
                        color: AppColors.brandYellow,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'OFFICIAL STORE',
                style: TextStyle(
                  color: Color(0x80FFFFFF),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Purchase',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const Text(
            'your eSIM',
            style: TextStyle(
              color: AppColors.brandYellow,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const SizedBox(
            width: 240,
            child: Text(
              'Instant activation • 207 countries • delivered by email',
              style: TextStyle(
                color: Color(0xCCFFFFFF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhysicalHero extends StatelessWidget {
  const _PhysicalHero({required this.onSetup});
  final VoidCallback onSetup;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.slate850, Color(0xFF334155)],
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.brandOrange,
                      AppColors.brandOrangeLight
                    ],
                  ),
                ),
                child: const Icon(Icons.credit_card,
                    color: AppColors.white, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bind your SIM',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track delivery & activate your physical SIM card',
                      style: TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Set Up Now',
            icon: Icons.arrow_forward,
            onPressed: onSetup,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Search + section title (reused inside the slivers)
// ─────────────────────────────────────────────────────────────────────

class _SectionSearchBar extends StatelessWidget {
  const _SectionSearchBar({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppColors.textWeak, fontSize: 14),
        filled: true,
        fillColor: AppColors.cardBackground,
        prefixIcon: const Icon(Icons.search,
            size: 18, color: AppColors.textWeak),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// eSIM country list (popular-first, single card with dividers)
// ─────────────────────────────────────────────────────────────────────

class _EsimCountrySliver extends StatelessWidget {
  const _EsimCountrySliver({required this.async, required this.query});
  final AsyncValue<List<Country>> async;
  final String query;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => const SliverPadding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.sm,
          AppSpacing.pageHorizontal,
          0,
        ),
        sliver: SliverToBoxAdapter(child: _ListSkeleton()),
      ),
      error: (e, _) => SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageHorizontal,
          AppSpacing.sm,
          AppSpacing.pageHorizontal,
          0,
        ),
        sliver: SliverToBoxAdapter(
          child: _InlineError(message: e.toString()),
        ),
      ),
      data: (countries) {
        final q = query;
        final filtered = q.isEmpty
            ? countries
            : countries
                .where((c) =>
                    c.name.toLowerCase().contains(q) ||
                    c.code.toLowerCase().contains(q))
                .toList();

        // Popular-first ordering (only when not searching).
        final sorted = q.isEmpty
            ? (_popularFirst(filtered))
            : filtered;

        if (sorted.isEmpty) {
          return const SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.sm,
              AppSpacing.pageHorizontal,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: _EmptyState(label: 'No countries match your search'),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            0,
            AppSpacing.pageHorizontal,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: CountryListCard(
              countries: sorted,
              showSeparatorAfterPopular: q.isEmpty,
              onTap: (country) => context.push(
                '${RouteNames.countryPackages}/${country.code}',
                extra: country,
              ),
            ),
          ),
        );
      },
    );
  }

  static List<Country> _popularFirst(List<Country> src) {
    final popular = <Country>[];
    final rest = <Country>[];
    for (final c in src) {
      if (isPopularCountry(c.code)) {
        popular.add(c);
      } else {
        rest.add(c);
      }
    }
    return [...popular, ...rest];
  }
}

// ─────────────────────────────────────────────────────────────────────
// Physical SIM body — US-only for now, mirrors H5 country-header + grid.
// (The plan grid itself can come later; for now we route to the activation
// wizard since real SIM card product catalog isn't wired yet.)
// ─────────────────────────────────────────────────────────────────────

class _PhysicalSimSliver extends StatelessWidget {
  const _PhysicalSimSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.lg,
        AppSpacing.pageHorizontal,
        0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const _SectionTitle(title: 'Purchase SIM Cards'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppRadius.r12),
              border: Border.all(color: AppColors.borderDefault),
              boxShadow: AppShadows.subtle,
            ),
            child: const Row(
              children: [
                _FlagPill(code: 'US'),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'United States',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _OrangeBadge(text: '3 Plans'),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        'AT&T · Verizon · T-Mobile · 3G/4G/5G',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textWeak,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'Physical SIM catalogue wires up in the next backend pass. Tap '
              '"Set Up Now" on the hero above to bind a SIM you already have.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textWeak,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _FlagPill extends StatelessWidget {
  const _FlagPill({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final emoji = _toFlagEmoji(code);
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.fillLight,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 22)),
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

class _OrangeBadge extends StatelessWidget {
  const _OrangeBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD7B8)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.brandOrange,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Skeletons + error + empty helpers
// ─────────────────────────────────────────────────────────────────────

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (_) => Container(
          height: 56,
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.fillLight,
            borderRadius: BorderRadius.circular(AppRadius.r12),
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
    return Container(
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

