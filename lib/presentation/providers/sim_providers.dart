import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../data/datasources/remote/sim_api.dart';
import '../../data/repositories/sim_repository_impl.dart';
import '../../domain/entities/recharge_package.dart';
import '../../domain/entities/sim.dart';
import '../../domain/repositories/sim_repository.dart';

final simApiProvider = Provider<SimApi>((ref) {
  return SimApi(ref.watch(dioProvider));
});

final simRepositoryProvider = Provider<SimRepository>((ref) {
  return SimRepositoryImpl(ref.watch(simApiProvider));
});

/// The user's SIM list (eSIM + physical).
final userSimsProvider = FutureProvider.autoDispose<List<Sim>>((ref) async {
  final repo = ref.watch(simRepositoryProvider);
  final r = await repo.listSims();
  return r.match((l) => throw l, (r) => r);
});

final rechargePackagesProvider =
    FutureProvider.autoDispose<List<RechargePackage>>((ref) async {
  final repo = ref.watch(simRepositoryProvider);
  final r = await repo.rechargePackages();
  return r.match((l) => throw l, (r) => r);
});

/// Detail + usage for a specific SIM.  Refreshes when invalidated.
final simDetailProvider =
    FutureProvider.autoDispose.family<Sim, String>((ref, iccid) async {
  final repo = ref.watch(simRepositoryProvider);
  final r = await repo.esimDetail(iccid);
  return r.match((l) => throw l, (r) => r);
});
