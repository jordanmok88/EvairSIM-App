import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

/// Bottom-nav shell used by GoRouter's StatefulShellRoute.
class RootShell extends StatelessWidget {
  const RootShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          boxShadow: AppShadows.sm,
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (idx) => navigationShell.goBranch(
              idx,
              initialLocation: idx == navigationShell.currentIndex,
            ),
            backgroundColor: AppColors.cardBackground,
            elevation: 0,
            indicatorColor: AppColors.brandOrange.withValues(alpha: 0.15),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.shopping_bag_outlined),
                selectedIcon: const Icon(
                  Icons.shopping_bag,
                  color: AppColors.brandOrange,
                ),
                label: strings.tabShop,
              ),
              NavigationDestination(
                icon: const Icon(Icons.sim_card_outlined),
                selectedIcon: const Icon(
                  Icons.sim_card,
                  color: AppColors.brandOrange,
                ),
                label: strings.tabSims,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(
                  Icons.person,
                  color: AppColors.brandOrange,
                ),
                label: strings.tabProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
