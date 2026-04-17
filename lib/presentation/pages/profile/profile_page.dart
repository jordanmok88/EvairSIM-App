import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/i18n/app_locale.dart';
import '../../../core/i18n/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/auth_providers.dart';
import '../../providers/locale_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.user;
    final strings = AppStrings.of(context);
    final currentLocale = ref.watch(localeControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                gradient: AppGradients.heroDark,
                borderRadius: AppRadius.card,
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.white.withValues(alpha: 0.2),
                    child: Text(
                      (user?.name ?? user?.email ?? 'U')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Guest',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '—',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _MenuCard(items: [
              _MenuItem(
                icon: Icons.inbox,
                label: strings.profileInbox,
                onTap: () => context.push(RouteNames.inbox),
              ),
              _MenuItem(
                icon: Icons.mail_outline,
                label: strings.profileContact,
                onTap: () => context.push(RouteNames.contact),
              ),
              _MenuItem(
                icon: Icons.receipt_long_outlined,
                label: strings.profileOrders,
                onTap: () => context.push(RouteNames.orders),
              ),
              _MenuItem(
                icon: Icons.language,
                label: strings.profileLanguage,
                trailing: Text(
                  currentLocale.label,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                onTap: () => _showLanguagePicker(context, ref),
              ),
              _MenuItem(
                icon: Icons.info_outline,
                label: strings.profileAbout,
                trailing: const Text('v1.0.0',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textWeak)),
                onTap: () {},
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            TextButton.icon(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) context.go(RouteNames.login);
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(
                strings.profileLogout,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

void _showLanguagePicker(BuildContext context, WidgetRef ref) {
  final strings = AppStrings.of(context);
  final currentLocale = ref.read(localeControllerProvider);
  showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    backgroundColor: AppColors.cardBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: AppRadius.bottomSheet,
    ),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                strings.profileLanguage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final lang in AppLocale.values)
            ListTile(
              leading: Text(lang.flag, style: const TextStyle(fontSize: 22)),
              title: Text(lang.label),
              trailing: lang == currentLocale
                  ? const Icon(Icons.check, color: AppColors.brandOrange)
                  : null,
              onTap: () {
                ref.read(localeControllerProvider.notifier).set(lang);
                Navigator.of(ctx).pop();
              },
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    ),
  );
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.items});
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              const Divider(height: 1, color: AppColors.borderDefault),
          ],
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 20),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing!,
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right,
              color: AppColors.textWeak, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }
}
