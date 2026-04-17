import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../data/datasources/remote/package_api.dart';
import '../../data/repositories/package_repository_impl.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/package.dart';
import '../../domain/repositories/package_repository.dart';

final packageApiProvider = Provider<PackageApi>(
  (ref) => PackageApi(ref.watch(dioProvider)),
);

final packageRepositoryProvider = Provider<PackageRepository>(
  (ref) => PackageRepositoryImpl(ref.watch(packageApiProvider)),
);

/// Country list (auto-refresh forever — the list is stable).
final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final result = await ref.watch(packageRepositoryProvider).listCountries();
  return result.fold((f) => throw Exception(f.message), (list) => list);
});

/// Hot/popular packages for the landing tab.
final hotPackagesProvider = FutureProvider<List<Package>>((ref) async {
  final result =
      await ref.watch(packageRepositoryProvider).listHotPackages(limit: 12);
  return result.fold((f) => throw Exception(f.message), (list) => list);
});

/// Packages filtered by country (nullable means "all").
final packagesByCountryProvider =
    FutureProvider.family<List<Package>, String?>((ref, location) async {
  final result = await ref.watch(packageRepositoryProvider).listPackages(
        location: location,
        page: 1,
        perPage: 50,
      );
  return result.fold((f) => throw Exception(f.message), (list) => list);
});
