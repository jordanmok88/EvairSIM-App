import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/auth_providers.dart';
import '../../providers/sim_type_provider.dart';
import '../../widgets/buttons/primary_button.dart';

/// Shop — post-April-2026 pivot (PCCW physical + Red Tea eSIM, no marketplace).
///
/// Mirrors the H5 `ShopView` shell: white sticky header, SIM Card / eSIM
/// segmented toggle, mode-specific hero card. Instead of the old country
/// browse, the body now shows a clear "how-to" + a primary CTA that routes
/// to either the PCCW activation wizard or the Red Tea eSIM connect page.
class ShopPage extends ConsumerWidget {
  const ShopPage({super.key, this.embedded = false});

  /// When true, renders only the body content (no Scaffold, SafeArea, or
  /// sticky header) so it can be composed inside [HomeShell]. Standalone
  /// usage still works for deep links.
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final simType = ref.watch(simTypeControllerProvider);

    final body = ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.xxl,
      ),
      children: [
        _HeroCard(
          simType: simType,
          onPhysical: () => context.push(RouteNames.physicalSim),
          onEsim: () => context.push(RouteNames.connectEsim),
        ),
        const SizedBox(height: AppSpacing.lg),
        _HowItWorksCard(simType: simType),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: simType == SimType.physical
              ? 'Activate PCCW SIM'
              : 'Connect eSIM',
          icon: simType == SimType.physical
              ? Icons.credit_card
              : Icons.link,
          onPressed: () => simType == SimType.physical
              ? context.push(RouteNames.physicalSim)
              : context.push(RouteNames.connectEsim),
        ),
        const SizedBox(height: AppSpacing.lg),
        _BuyElsewhereNote(simType: simType),
      ],
    );

    if (embedded) return body;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            _ShopHeader(
              userName: user?.name,
              userEmail: user?.email,
              simType: simType,
              onSimTypeChanged: (t) =>
                  ref.read(simTypeControllerProvider.notifier).set(t),
              onInboxTap: () => context.push(RouteNames.inbox),
              onAvatarTap: () => context.push(RouteNames.profile),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Header — white sticky bar with greeting + bell + avatar + toggle.
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
                'Activate your SIM and top up in seconds',
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
// SIM Card / eSIM segmented toggle.
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
// Hero card — mode-specific, tappable.
// ─────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.simType,
    required this.onPhysical,
    required this.onEsim,
  });
  final SimType simType;
  final VoidCallback onPhysical;
  final VoidCallback onEsim;

  @override
  Widget build(BuildContext context) {
    return simType == SimType.physical
        ? _PhysicalHero(onTap: onPhysical)
        : _EsimHero(onTap: onEsim);
  }
}

class _PhysicalHero extends StatelessWidget {
  const _PhysicalHero({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Container(
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
                          'Activate your PCCW SIM',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Scan the barcode or enter the ICCID printed on your card',
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
              const Row(
                children: [
                  _Pill(label: 'PCCW Hong Kong'),
                  SizedBox(width: 6),
                  _Pill(label: 'Global roaming'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EsimHero extends StatelessWidget {
  const _EsimHero({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Container(
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
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      color: const Color(0x33FFFFFF),
                    ),
                    child: const Icon(Icons.link_rounded,
                        color: AppColors.white, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connect your eSIM',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Paste the ICCID + LPA code from your activation email',
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
              const Row(
                children: [
                  _Pill(label: 'Red Tea'),
                  SizedBox(width: 6),
                  _Pill(label: 'Instant install'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// How it works — 3-step instructions, mode-specific.
// ─────────────────────────────────────────────────────────────────────

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.simType});
  final SimType simType;

  List<_Step> get _steps => simType == SimType.physical
      ? const [
          _Step(
            icon: Icons.shopping_bag_outlined,
            title: 'Buy a PCCW SIM',
            body:
                'Get yours from Amazon, Temu, or evairdigital.com — we don\'t sell hardware in the app.',
          ),
          _Step(
            icon: Icons.qr_code_scanner,
            title: 'Scan or enter the ICCID',
            body:
                'The 18–22 digit number is printed next to the barcode on the card.',
          ),
          _Step(
            icon: Icons.flash_on_outlined,
            title: 'Top up from My SIMs',
            body:
                'Pick a 30 / 60 / 90 / 180-day plan managed by the admin portal.',
          ),
        ]
      : const [
          _Step(
            icon: Icons.email_outlined,
            title: 'Get your activation email',
            body:
                'After we issue your Red Tea eSIM, you\'ll receive an email with the ICCID and LPA code.',
          ),
          _Step(
            icon: Icons.content_paste_go,
            title: 'Paste the codes here',
            body:
                'Tap "Connect eSIM" and drop in the two values from the email.',
          ),
          _Step(
            icon: Icons.qr_code_2,
            title: 'Install to your device',
            body:
                'From My SIMs, scan the QR with your phone\'s camera to install the profile (one time only).',
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How it works',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (int i = 0; i < _steps.length; i++) ...[
            _Step.render(_steps[i], index: i + 1),
            if (i != _steps.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _Step {
  const _Step({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  static Widget render(_Step step, {required int index}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.brandOrange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.r10),
          ),
          child: Icon(step.icon, color: AppColors.brandOrange, size: 18),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$index. ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brandOrange,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                step.body,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Secondary note
// ─────────────────────────────────────────────────────────────────────

class _BuyElsewhereNote extends StatelessWidget {
  const _BuyElsewhereNote({required this.simType});
  final SimType simType;

  @override
  Widget build(BuildContext context) {
    final text = simType == SimType.physical
        ? 'We only sell PCCW SIM cards on Amazon, Temu and evairdigital.com. Bring yours here to activate.'
        : 'Red Tea eSIMs are issued via email. Didn\'t get one? Contact support from your profile.';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.fillLight,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
