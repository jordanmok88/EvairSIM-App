import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/auth_providers.dart';
import '../../providers/sim_providers.dart';
import '../../providers/sim_type_provider.dart';
import '../shop/shop_page.dart';
import '../sims/my_sims_page.dart';

/// Primary screen post-April-2026 pivot.
///
/// Mirrors the H5 layout EXACTLY:
///   • No bottom nav.
///   • Sticky top bar with greeting + bell (inbox) + avatar (profile).
///   • Large SIM Card / eSIM segmented toggle (app-wide product switch).
///   • Shop / My SIMs sub-pill controlling the body.
///   • Body is an IndexedStack over the embedded Shop and My SIMs bodies so
///     scroll state and providers stay warm while switching.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

enum _ViewMode { shop, mySims }

class _HomeShellState extends ConsumerState<HomeShell> {
  _ViewMode _mode = _ViewMode.shop;

  @override
  void initState() {
    super.initState();
    // Land on My SIMs when the user already has bound SIMs — matches the
    // H5 `ProductTab` behaviour (viewMode defaults to 'MINE' if mySims > 0).
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final sims = await ref.read(userSimsProvider.future);
      if (!mounted) return;
      if (sims.isNotEmpty && _mode == _ViewMode.shop) {
        setState(() => _mode = _ViewMode.mySims);
      }
    });
  }

  void _setMode(_ViewMode m) {
    if (_mode != m) setState(() => _mode = m);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final simType = ref.watch(simTypeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(
              userName: user?.name,
              userEmail: user?.email,
              onInboxTap: () => context.push(RouteNames.inbox),
              onAvatarTap: () => context.push(RouteNames.profile),
            ),
            _SimTypeToggle(
              value: simType,
              onChanged: (t) =>
                  ref.read(simTypeControllerProvider.notifier).set(t),
            ),
            _ViewModeTabs(
              value: _mode,
              onChanged: _setMode,
            ),
            const _Divider(),
            Expanded(
              child: IndexedStack(
                index: _mode == _ViewMode.shop ? 0 : 1,
                children: const [
                  ShopPage(embedded: true),
                  MySimsPage(embedded: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Top bar: greeting + bell + avatar
// ─────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
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

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.sm,
      ),
      decoration: const BoxDecoration(color: AppColors.cardBackground),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isGuest
                      ? 'Hello, New Friend'
                      : 'Hello, $displayName',
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
          _AvatarBubble(
            initial: isGuest ? null : initial,
            onTap: onAvatarTap,
          ),
        ],
      ),
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

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.initial, required this.onTap});

  /// null when user is logged out → shows a generic person icon like the H5.
  final String? initial;
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
          child: initial == null
              ? const Icon(Icons.person, color: AppColors.white, size: 20)
              : Text(
                  initial!,
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

// ─────────────────────────────────────────────────────────────
// SIM Card / eSIM toggle (big, branded — the primary product switch)
// ─────────────────────────────────────────────────────────────

class _SimTypeToggle extends StatelessWidget {
  const _SimTypeToggle({required this.value, required this.onChanged});
  final SimType value;
  final ValueChanged<SimType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.sm + 2,
      ),
      child: LayoutBuilder(
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
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: selected ? AppColors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: selected ? AppColors.white : AppColors.textSecondary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Secondary: Shop / My SIMs pill
// ─────────────────────────────────────────────────────────────

class _ViewModeTabs extends StatelessWidget {
  const _ViewModeTabs({required this.value, required this.onChanged});
  final _ViewMode value;
  final ValueChanged<_ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        0,
        AppSpacing.pageHorizontal,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ViewModeBtn(
              label: 'Shop',
              selected: value == _ViewMode.shop,
              onTap: () => onChanged(_ViewMode.shop),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ViewModeBtn(
              label: 'My SIMs',
              selected: value == _ViewMode.mySims,
              onTap: () => onChanged(_ViewMode.mySims),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModeBtn extends StatelessWidget {
  const _ViewModeBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.textPrimary : AppColors.cardBackground,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          alignment: Alignment.center,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? AppColors.textPrimary
                  : AppColors.borderDefault,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: selected ? AppColors.white : AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.borderDefault,
    );
  }
}
