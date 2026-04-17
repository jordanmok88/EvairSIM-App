// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recharge_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RechargePackageImpl _$$RechargePackageImplFromJson(
  Map<String, dynamic> json,
) => _$RechargePackageImpl(
  packageCode: json['package_code'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'USD',
  dataBytes: (json['data_amount'] as num?)?.toInt(),
  validityDays: (json['validity_days'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toInt(),
  durationUnit: json['duration_unit'] as String?,
);

Map<String, dynamic> _$$RechargePackageImplToJson(
  _$RechargePackageImpl instance,
) => <String, dynamic>{
  'package_code': instance.packageCode,
  'name': instance.name,
  'price': instance.price,
  'currency': instance.currency,
  'data_amount': instance.dataBytes,
  'validity_days': instance.validityDays,
  'duration': instance.duration,
  'duration_unit': instance.durationUnit,
};
