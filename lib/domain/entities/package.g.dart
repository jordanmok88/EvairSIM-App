// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageImpl _$$PackageImplFromJson(Map<String, dynamic> json) =>
    _$PackageImpl(
      packageCode: json['package_code'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      volume: (json['volume'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      durationUnit: json['duration_unit'] as String? ?? 'DAY',
      location: json['location'] as String? ?? '',
      locationName: json['location_name'] as String? ?? '',
      type: json['type'] as String? ?? 'BASE',
      speed: json['speed'] as String? ?? '4G',
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      description: json['description'] as String?,
      salesCount: (json['sales_count'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PackageImplToJson(_$PackageImpl instance) =>
    <String, dynamic>{
      'package_code': instance.packageCode,
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
      'volume': instance.volume,
      'duration': instance.duration,
      'duration_unit': instance.durationUnit,
      'location': instance.location,
      'location_name': instance.locationName,
      'type': instance.type,
      'speed': instance.speed,
      'features': instance.features,
      'description': instance.description,
      'sales_count': instance.salesCount,
      'rating': instance.rating,
    };
