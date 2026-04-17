import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';

/// Milestone 0 smoke-test screen.
/// Confirms theme system (colors, gradients, shadows, radius, Inter font) works.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxxl),

              // Brand hero card
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  gradient: AppGradients.heroDark,
                  borderRadius: AppRadius.hero,
                  boxShadow: AppShadows.brandCard,
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'EvairSIM',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        'eSIM & SIM Management',
                        style: TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Status card
              Container(
                padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: AppRadius.card,
                  boxShadow: AppShadows.card,
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.successBg,
                            borderRadius:
                                BorderRadius.circular(AppRadius.r10),
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.successDeep,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          'Milestone 0 — Foundation',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Theme system, routing, and API client are wired up. '
                      'Next: Login & Register (Milestone 1).',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Primary CTA button (preview style)
              Container(
                decoration: const BoxDecoration(
                  gradient: AppGradients.primaryButton,
                  borderRadius: AppRadius.button,
                  boxShadow: AppShadows.brandButton,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.go(RouteNames.login),
                    borderRadius: AppRadius.button,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
