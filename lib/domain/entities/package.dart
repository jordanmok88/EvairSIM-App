import 'package:freezed_annotation/freezed_annotation.dart';

part 'package.freezed.dart';
part 'package.g.dart';

/// eSIM package returned by GET /v1/h5/packages and friends.
@freezed
class Package with _$Package {
  const factory Package({
    @JsonKey(name: 'package_code') required String packageCode,
    required String name,
    required double price,
    @Default('USD') String currency,

    /// Total data volume in BYTES. Convert with [volumeDisplay].
    @Default(0) int volume,

    /// Duration value (e.g. 7 for 7-day plan).
    @Default(0) int duration,
    @JsonKey(name: 'duration_unit') @Default('DAY') String durationUnit,

    /// ISO country code the plan belongs to (e.g. "US", "MX").
    @Default('') String location,
    @JsonKey(name: 'location_name') @Default('') String locationName,

    /// BASE = standalone plan, TOPUP = recharge, UNLIMITED etc.
    @Default('BASE') String type,

    @Default('4G') String speed,
    @Default(<String>[]) List<String> features,
    String? description,

    /// Only present on /packages/hot
    @JsonKey(name: 'sales_count') int? salesCount,
    double? rating,
  }) = _Package;

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);

  const Package._();

  /// Human-friendly volume, e.g. "1 GB", "500 MB".
  String get volumeDisplay {
    if (volume <= 0) return '—';
    const gb = 1024 * 1024 * 1024;
    const mb = 1024 * 1024;
    if (volume >= gb) {
      final v = volume / gb;
      return v == v.roundToDouble()
          ? '${v.toInt()} GB'
          : '${v.toStringAsFixed(1)} GB';
    }
    final v = volume / mb;
    return '${v.toInt()} MB';
  }

  /// e.g. "7 days", "30 days".
  String get durationDisplay {
    if (duration <= 0) return '—';
    final unit = durationUnit.toLowerCase();
    final label = unit.startsWith('day')
        ? (duration == 1 ? 'day' : 'days')
        : unit;
    return '$duration $label';
  }

  String get priceDisplay => '\$${price.toStringAsFixed(2)}';
}
