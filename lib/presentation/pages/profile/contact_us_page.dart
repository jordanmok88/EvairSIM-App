import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  static const _email = 'service@evairdigital.com';
  static const _website = 'https://evairdigital.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contact us'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            const Text(
              'We usually reply within one business day.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ContactCard(
              icon: Icons.mail_outline,
              title: 'Email support',
              subtitle: _email,
              onTap: () => launchUrl(Uri.parse('mailto:$_email')),
            ),
            const SizedBox(height: AppSpacing.md),
            _ContactCard(
              icon: Icons.language,
              title: 'Website',
              subtitle: _website.replaceFirst('https://', ''),
              onTap: () => launchUrl(
                Uri.parse(_website),
                mode: LaunchMode.externalApplication,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _ContactCard(
              icon: Icons.chat_bubble_outline,
              title: 'Live chat',
              subtitle: 'Opens Monday–Friday, 09:00–18:00 GMT+8',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Live chat is coming soon.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: AppRadius.card,
            boxShadow: AppShadows.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: Icon(icon, color: AppColors.brandOrange),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.textWeak, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
