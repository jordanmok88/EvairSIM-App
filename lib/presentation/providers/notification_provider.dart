import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../data/datasources/remote/notification_api.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

final notificationApiProvider = Provider<NotificationApi>((ref) {
  return NotificationApi(ref.watch(dioProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(notificationApiProvider));
});

/// Latest active notifications from the admin portal.  Auto-disposes so
/// the inbox page always fetches fresh when revisited.
final notificationsProvider =
    FutureProvider.autoDispose<List<AppNotification>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  final r = await repo.list();
  return r.match((l) => throw l, (r) => r);
});
