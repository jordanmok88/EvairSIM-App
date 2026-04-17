import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';

/// Wraps the app in an iPhone-shaped frame on desktop/tablet (>= 640 px).
/// On mobile the child fills the screen.
///
/// This matches the design-system spec: desktop width 430, height 880,
/// radius 56, 8 px dark bezel, phoneFrame shadow.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  static const double breakpoint = 640;
  static const double frameWidth = 430;
  static const double frameHeight = 880;
  static const double bezel = 8;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < breakpoint;

    if (isMobile) return child;

    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Container(
          width: frameWidth,
          height: frameHeight,
          padding: const EdgeInsets.all(bezel),
          decoration: BoxDecoration(
            color: AppColors.slate850,
            borderRadius: BorderRadius.circular(AppRadius.r56),
            boxShadow: AppShadows.phoneFrame,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r56 - bezel),
            child: MediaQuery(
              // Simulate iPhone viewport so child layouts correctly
              data: MediaQuery.of(context).copyWith(
                size: const Size(
                  frameWidth - bezel * 2,
                  frameHeight - bezel * 2,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
