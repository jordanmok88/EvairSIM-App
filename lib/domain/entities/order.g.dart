// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppOrderImpl _$$AppOrderImplFromJson(Map<String, dynamic> json) =>
    _$AppOrderImpl(
      orderNo: _readOrderNo(json, 'order_no') as String,
      status: _readStatus(json, 'status') as String,
      amount: (_readAmount(json, 'amount') as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      packageCode: json['package_code'] as String?,
      packageName: json['package_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      lpaCode: _readLpa(json, 'lpa_code') as String?,
      iccid: json['iccid'] as String?,
    );

Map<String, dynamic> _$$AppOrderImplToJson(_$AppOrderImpl instance) =>
    <String, dynamic>{
      'order_no': instance.orderNo,
      'status': instance.status,
      'amount': instance.amount,
      'currency': instance.currency,
      'package_code': instance.packageCode,
      'package_name': instance.packageName,
      'created_at': instance.createdAt?.toIso8601String(),
      'paid_at': instance.paidAt?.toIso8601String(),
      'lpa_code': instance.lpaCode,
      'iccid': instance.iccid,
    };
