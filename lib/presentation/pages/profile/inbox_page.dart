import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/i18n/app_locale.dart';
import '../../../core/i18n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/app_notification.dart';
import '../../providers/locale_provider.dart';
import '../../providers/notification_provider.dart';

/// Customer-facing inbox.  Pulls from the admin portal's 通知管理 feed via
/// `GET /v1/h5/notifications`, auto-localises title/body based on the user's
/// selected app language, and supports simple client-side filtering.
///
/// Parity with H5 InboxView.tsx: pill-style filter row, unread header
/// (derived locally since the backend hasn't exposed `read_at` yet), timeago
/// metadata, and card style.
class InboxPage extends ConsumerStatefulWidget {
  const InboxPage({super.key});

  @override
  ConsumerState<InboxPage> createState() => _InboxPageState();
}

enum _InboxFilter { all, alerts, orders, promos }

class _InboxPageState extends ConsumerState<InboxPage> {
  _InboxFilter _filter = _InboxFilter.all;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final locale = ref.watch(localeControllerProvider);
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(strings.inboxTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: AppColors.brandOrange,
        onRefresh: () async {
          ref.invalidate(notificationsProvider);
          await ref.read(notificationsProvider.future);
        },
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(message: e.toString(), onRetry: () {
            ref.invalidate(notificationsProvider);
          }),
          data: (all) {
            final filtered = _applyFilter(all, _filter);
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.sm,
                      AppSpacing.pageHorizontal,
                      AppSpacing.sm,
                    ),
                    child: _FilterRow(
                      current: _filter,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyView(strings: strings),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      0,
                      AppSpacing.pageHorizontal,
                      AppSpacing.xl,
                    ),
                    sliver: SliverList.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) {
                        return _NotificationCard(
                          notification: filtered[i],
                          locale: locale,
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<AppNotification> _applyFilter(
    List<AppNotification> source,
    _InboxFilter filter,
  ) {
    switch (filter) {
      case _InboxFilter.all:
        return source;
      case _InboxFilter.alerts:
        return source
            .where((n) => n.type.toLowerCase() == 'service')
            .toList(growable: false);
      case _InboxFilter.orders:
        // The admin portal tags order updates as `service` + `action_label`.
        // Keep this bucket open for future dedicated `order` type.
        return source
            .where(
              (n) => (n.actionLabel ?? '').isNotEmpty &&
                  n.type.toLowerCase() != 'promo',
            )
            .toList(growable: false);
      case _InboxFilter.promos:
        return source
            .where((n) => n.type.toLowerCase() == 'promo')
            .toList(growable: false);
    }
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.current, required this.onChanged});
  final _InboxFilter current;
  final ValueChanged<_InboxFilter> onChanged;

  static const List<(_InboxFilter, String)> _items = [
    (_InboxFilter.all, 'All'),
    (_InboxFilter.alerts, 'Alerts'),
    (_InboxFilter.orders, 'Orders'),
    (_InboxFilter.promos, 'Promos'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final item in _items) ...[
            _FilterPill(
              label: item.$2,
              active: item.$1 == current,
              onTap: () => onChanged(item.$1),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.brandOrange : AppColors.cardBackground,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: active ? AppColors.white : AppColors.textSecondary,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.locale,
  });
  final AppNotification notification;
  final AppLocale locale;

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor, tint) = _typeVisuals(notification);
    final title = notification.titleFor(locale);
    final body = notification.bodyFor(locale);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title.isEmpty ? 'Notification' : title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _timeAgo(notification.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textWeak,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
                if ((notification.actionLabel ?? '').isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      notification.actionLabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandOrange,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static (IconData, Color, Color) _typeVisuals(AppNotification n) {
    if (n.isPromo) {
      return (
        Icons.local_offer_outlined,
        const Color(0xFF8B5CF6),
        const Color(0xFFF5F3FF),
      );
    }
    // Default 'service' bucket (covers order + generic service posts).
    return (
      Icons.bolt_outlined,
      const Color(0xFF3B82F6),
      const Color(0xFFEFF6FF),
    );
  }

  static String _timeAgo(DateTime? when) {
    if (when == null) return '';
    final diff = DateTime.now().difference(when);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    final weeks = (diff.inDays / 7).floor();
    if (weeks < 5) return '${weeks}w';
    final months = (diff.inDays / 30).floor();
    return '${months}mo';
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.strings});
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppRadius.r16),
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                size: 48,
                color: AppColors.brandOrange,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              strings.inboxEmpty,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.inboxEmptyDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 40, color: AppColors.textWeak),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
