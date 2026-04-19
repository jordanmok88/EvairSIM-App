import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../providers/sim_type_provider.dart';
import '../../../widgets/buttons/primary_button.dart';

/// Rich empty-state surface shown inside My SIMs when the user has no bound
/// SIMs of the currently-selected type. Post-April-2026 pivot the app doesn't
/// sell plans, so this IS our primary CTA — a branded bind/connect hero plus
/// a "how it works" card and a small "where to buy" note.
///
/// Layout (vertical):
///   1. Hero card (dark navy "Bind your SIM Card" OR red-gradient
///      "EvairSIM · Connect Your eSIM")
///   2. How it works — 3 numbered steps
///   3. Loud primary CTA routing to the activation / connect wizard
///   4. Secondary "buy elsewhere" info note
///
/// Ported 1:1 from the retired `ShopPage` so users don't see any layout
/// regression after the Shop surface was deleted.
class BindHeroBlock extends StatelessWidget {
  const BindHeroBlock({super.key, required this.simType});

  final SimType simType;

  @override
  Widget build(BuildContext context) {
    final isEsim = simType == SimType.esim;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          label: isEsim ? 'Connect eSIM' : 'Activate SIM Card',
          icon: isEsim ? Icons.link : Icons.credit_card,
          onPressed: () => context.push(
            isEsim ? RouteNames.connectEsim : RouteNames.physicalSim,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _BuyElsewhereNote(simType: simType),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Hero card — mode-specific.
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

/// SIM Card (physical) hero — 1:1 port of the H5 dark navy "Bind your SIM
/// Card" card.
class _PhysicalHero extends StatelessWidget {
  const _PhysicalHero({required this.onTap});
  final VoidCallback onTap;

  static const _slate900 = Color(0xFF1E293B);
  static const _slate700 = Color(0xFF334155);
  static const _slate400 = Color(0xFF94A3B8);
  static const _slate300 = Color(0xFFCBD5E1);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_slate900, _slate700],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x33FF6600), Colors.transparent],
                  stops: [0, 0.7],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.brandOrange,
                            AppColors.brandOrangeLight,
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
                            'Bind your SIM Card',
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
                              color: _slate400,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
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
                    _HeroChip(
                      icon: Icons.local_shipping_outlined,
                      label: 'Delivery Tracking',
                      textColor: _slate300,
                    ),
                    SizedBox(width: AppSpacing.md),
                    _HeroChip(
                      icon: Icons.smartphone,
                      label: 'SIM Activation',
                      textColor: _slate300,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _HeroCta(label: 'Set Up Now', onTap: onTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// eSIM hero — 1:1 port of the H5 red-orange "EvairSIM OFFICIAL STORE" card.
class _EsimHero extends StatelessWidget {
  const _EsimHero({required this.onTap});
  final VoidCallback onTap;

  static const _gold = Color(0xFFFFCC33);
  static const _deepRed = Color(0xFFCC0000);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brandOrange, _deepRed],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26CC0000),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -64,
                right: -64,
                child: Container(
                  width: 192,
                  height: 192,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x33FFCC33), Colors.transparent],
                      stops: [0, 0.7],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -48,
                left: -48,
                child: Container(
                  width: 144,
                  height: 144,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x26FF6600), Colors.transparent],
                      stops: [0, 0.7],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _EvairLockup(),
                        Text(
                          'OFFICIAL STORE',
                          style: TextStyle(
                            color: Color(0x80FFFFFF),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Connect',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        height: 1.05,
                      ),
                    ),
                    Text(
                      'Your eSIM',
                      style: TextStyle(
                        color: _gold,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm + 2),
                    SizedBox(
                      width: 250,
                      child: Text(
                        'Paste your activation code or scan the QR — your eSIM is ready in seconds.',
                        style: TextStyle(
                          color: Color(0xB3FFFFFF),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EvairLockup extends StatelessWidget {
  const _EvairLockup();
  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        children: [
          TextSpan(text: 'Evair', style: TextStyle(color: AppColors.white)),
          TextSpan(
            text: 'SIM',
            style: TextStyle(color: _EsimHero._gold),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
    required this.textColor,
  });
  final IconData icon;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.brandOrange),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HeroCta extends StatelessWidget {
  const _HeroCta({required this.label, required this.onTap});
  final String label;
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
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brandOrange, AppColors.brandOrangeLight],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4DFF6600),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right,
                  color: AppColors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// How it works — 3 numbered steps, mode-specific.
// ─────────────────────────────────────────────────────────────────────

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.simType});
  final SimType simType;

  List<_Step> get _steps => simType == SimType.physical
      ? const [
          _Step(
            icon: Icons.shopping_bag_outlined,
            title: 'Get an EvairSIM card',
            body:
                'Order one on Amazon, Temu, or evairdigital.com — we ship worldwide.',
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
                'After we issue your EvairSIM eSIM, you\'ll receive an email with the ICCID and LPA code.',
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
// Secondary "where to buy" note.
// ─────────────────────────────────────────────────────────────────────

class _BuyElsewhereNote extends StatelessWidget {
  const _BuyElsewhereNote({required this.simType});
  final SimType simType;

  @override
  Widget build(BuildContext context) {
    final text = simType == SimType.physical
        ? 'EvairSIM cards are sold on Amazon, Temu and evairdigital.com. Bring yours here to activate.'
        : 'eSIMs are issued via email. Didn\'t get one? Contact support from your profile.';
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
