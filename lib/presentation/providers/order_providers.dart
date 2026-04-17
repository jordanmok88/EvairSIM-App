import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasources/remote/order_api.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../core/network/api_client.dart';

final orderApiProvider = Provider<OrderApi>((ref) {
  return OrderApi(ref.watch(dioProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.watch(orderApiProvider));
});

/// Returns the authenticated user's orders (most recent first).
final ordersProvider = FutureProvider.autoDispose<List<AppOrder>>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  final result = await repo.listOrders();
  return result.match((l) => throw l, (r) => r);
});
