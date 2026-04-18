import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
import '../../providers/sim_providers.dart';

/// Profile tab — H5-faithful:
///  • Gradient hero with avatar + name + email
///  • Quick-stats strip (SIMs active, top-ups to date)
///  • Sectioned menu groups: Account · Support · Preferences · About
///  • App version footer + logout affordance
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const _shareUrl = 'https://evairdigital.com';
  static const _supportEmail = 'service@evairdigital.com';
  static const _appVersion = 'v1.0.0';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.user;
    final strings = AppStrings.of(context);
    final currentLocale = ref.watch(localeControllerProvider);
    final simsAsync = ref.watch(userSimsProvider);
    final ordersAsync = ref.watch(rechargeRecordsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.md,
            AppSpacing.pageHorizontal,
            AppSpacing.xl,
          ),
          children: [
            _HeroCard(
              name: user?.name ?? 'Guest',
              email: user?.email ?? '—',
            ),
            const SizedBox(height: AppSpacing.md),
            _QuickStatsRow(
              simCount: simsAsync.asData?.value.length ?? 0,
              topUpCount: ordersAsync.asData?.value.length ?? 0,
            ),
            const SizedBox(height: AppSpacing.lg),

            _SectionLabel(label: 'Account'),
            _MenuCard(items: [
              _MenuItem(
                icon: Icons.inbox,
                label: strings.profileInbox,
                onTap: () => context.push(RouteNames.inbox),
              ),
              _MenuItem(
                icon: Icons.receipt_long_outlined,
                label: 'Top-up history',
                onTap: () => context.push(RouteNames.orders),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),

            _SectionLabel(label: 'Support'),
            _MenuCard(items: [
              _MenuItem(
                icon: Icons.chat_bubble_outline,
                label: 'Live chat',
                onTap: () => context.push(RouteNames.liveChat),
              ),
              _MenuItem(
                icon: Icons.mail_outline,
                label: strings.profileContact,
                onTap: () => context.push(RouteNames.contact),
              ),
              _MenuItem(
                icon: Icons.ios_share_outlined,
                label: 'Share EvairSIM',
                onTap: () => SharePlus.instance.share(
                  ShareParams(
                    text: 'Stay connected worldwide with EvairSIM: $_shareUrl',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),

            _SectionLabel(label: 'Preferences'),
            _MenuCard(items: [
              _MenuItem(
                icon: Icons.language,
                label: strings.profileLanguage,
                trailing: Text(
                  '${currentLocale.flag}  ${currentLocale.label}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _showLanguagePicker(context, ref),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),

            _SectionLabel(label: 'About'),
            _MenuCard(items: [
              _MenuItem(
                icon: Icons.language_outlined,
                label: 'Visit evairdigital.com',
                onTap: () => launchUrl(
                  Uri.parse(_shareUrl),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              _MenuItem(
                icon: Icons.email_outlined,
                label: _supportEmail,
                onTap: () => launchUrl(Uri.parse('mailto:$_supportEmail')),
              ),
              _MenuItem(
                icon: Icons.info_outline,
                label: strings.profileAbout,
                trailing: const Text(
                  _appVersion,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textWeak,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _showAbout(context),
              ),
            ]),
            const SizedBox(height: AppSpacing.xl),

            _LogoutButton(
              label: strings.profileLogout,
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) context.go(RouteNames.login);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Center(
              child: Text(
                'EvairSIM · $_appVersion',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textWeak,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Hero + quick stats
// ─────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.name, required this.email});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final initial =
        (name.isNotEmpty ? name : (email.isNotEmpty ? email : 'U'))
            .substring(0, 1)
            .toUpperCase();
    return Container(
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
              initial,
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
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow({required this.simCount, required this.topUpCount});
  final int simCount;
  final int topUpCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: Icons.sim_card,
            value: simCount.toString(),
            label: simCount == 1 ? 'SIM active' : 'SIMs active',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatChip(
            icon: Icons.bolt_outlined,
            value: topUpCount.toString(),
            label: topUpCount == 1 ? 'Top-up' : 'Top-ups',
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandOrange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
            child: Icon(icon, color: AppColors.brandOrange, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Menu primitives
// ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.fillLight,
                borderRadius: BorderRadius.circular(AppRadius.r8),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 16),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right,
                color: AppColors.textWeak, size: 20),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.errorBg,
      borderRadius: AppRadius.card,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.card,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: AppColors.error, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sheets / dialogs
// ─────────────────────────────────────────────────────────────

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

void _showAbout(BuildContext context) {
  showAboutDialog(
    context: context,
    useRootNavigator: true,
    applicationName: 'EvairSIM',
    applicationVersion: ProfilePage._appVersion,
    applicationLegalese:
        '© 2026 Evair Digital. PCCW physical SIM activation + Red Tea eSIM connect.',
    children: const [
      SizedBox(height: 12),
      Text(
        'EvairSIM lets you activate PCCW physical SIMs and connect Red Tea '
        'eSIMs, then top them up with admin-portal-managed recharge packages.',
        style: TextStyle(fontSize: 13, height: 1.4),
      ),
    ],
  );
}
