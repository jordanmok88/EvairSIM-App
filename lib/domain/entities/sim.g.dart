// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sim.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SimImpl _$$SimImplFromJson(Map<String, dynamic> json) => _$SimImpl(
  iccid: json['iccid'] as String,
  status: json['status'] as String?,
  type: json['type'] as String?,
  packageName: json['package_name'] as String?,
  countryCode: json['country_code'] as String?,
  countryName: json['country_name'] as String?,
  totalBytes: (json['data_total_bytes'] as num?)?.toInt(),
  usedBytes: (json['data_used_bytes'] as num?)?.toInt(),
  remainingBytes: (json['data_remaining_bytes'] as num?)?.toInt(),
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  activatedAt: json['activated_at'] == null
      ? null
      : DateTime.parse(json['activated_at'] as String),
  qrcode: json['qrcode'] as String?,
  acCode: json['ac_code'] as String?,
  lpaCode: json['lpa_code'] as String?,
  smdpAddress: json['smdp_address'] as String?,
);

Map<String, dynamic> _$$SimImplToJson(_$SimImpl instance) => <String, dynamic>{
  'iccid': instance.iccid,
  'status': instance.status,
  'type': instance.type,
  'package_name': instance.packageName,
  'country_code': instance.countryCode,
  'country_name': instance.countryName,
  'data_total_bytes': instance.totalBytes,
  'data_used_bytes': instance.usedBytes,
  'data_remaining_bytes': instance.remainingBytes,
  'expires_at': instance.expiresAt?.toIso8601String(),
  'activated_at': instance.activatedAt?.toIso8601String(),
  'qrcode': instance.qrcode,
  'ac_code': instance.acCode,
  'lpa_code': instance.lpaCode,
  'smdp_address': instance.smdpAddress,
};
