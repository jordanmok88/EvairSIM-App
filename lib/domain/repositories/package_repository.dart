import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/country.dart';
import '../entities/package.dart';

abstract class PackageRepository {
  /// Fetches the list of single-country destinations.
  Future<Either<Failure, List<Country>>> listCountries();

  /// Fetches packages, optionally filtered by ISO country code.
  Future<Either<Failure, List<Package>>> listPackages({
    String? location,
    String? type,
    int page,
    int perPage,
  });

  Future<Either<Failure, List<Package>>> listHotPackages({int limit});
}
