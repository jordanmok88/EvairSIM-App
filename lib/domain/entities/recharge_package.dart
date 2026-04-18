import 'package:freezed_annotation/freezed_annotation.dart';

part 'recharge_package.freezed.dart';
part 'recharge_package.g.dart';

@freezed
class RechargePackage with _$RechargePackage {
  const factory RechargePackage({
    @JsonKey(name: 'package_code') required String packageCode,
    required String name,
    required double price,
    @Default('USD') String currency,
    @JsonKey(name: 'data_amount') int? dataBytes,
    @JsonKey(name: 'validity_days') int? validityDays,
    @JsonKey(name: 'duration') int? duration,
    @JsonKey(name: 'duration_unit') String? durationUnit,

    /// 'pccw' | 'esimaccess' — required when creating a recharge order so
    /// the admin portal knows which supplier template to snapshot.
    @JsonKey(name: 'supplier_type') @Default('pccw') String supplierType,

    /// Internal bookkeeping reference — not surfaced in UI.
    @JsonKey(name: 'package_source') String? packageSource,
    @JsonKey(name: 'location_code') String? locationCode,
  }) = _RechargePackage;

  factory RechargePackage.fromJson(Map<String, dynamic> json) =>
      _$RechargePackageFromJson(json);

  const RechargePackage._();

  String get priceDisplay => '\$${price.toStringAsFixed(2)}';

  String get volumeDisplay {
    final b = dataBytes;
    if (b == null || b <= 0) return 'Unlimited';
    const gb = 1024 * 1024 * 1024;
    if (b >= gb) {
      final v = b / gb;
      return v == v.roundToDouble()
          ? '${v.toInt()} GB'
          : '${v.toStringAsFixed(1)} GB';
    }
    return '${(b / (1024 * 1024)).toStringAsFixed(0)} MB';
  }

  String get durationDisplay {
    if (validityDays != null && validityDays! > 0) {
      return '${validityDays!} days';
    }
    if (duration != null && duration! > 0) {
      return '$duration ${durationUnit?.toLowerCase() ?? 'day'}';
    }
    return '--';
  }
}
