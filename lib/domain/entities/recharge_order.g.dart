// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recharge_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RechargeOrderImpl _$$RechargeOrderImplFromJson(Map<String, dynamic> json) =>
    _$RechargeOrderImpl(
      id: (json['id'] as num).toInt(),
      orderNo: json['order_id'] as String?,
      iccid: json['iccid'] as String?,
      planName: json['plan_name'] as String?,
      packageCode: json['package_code'] as String?,
      supplierType: json['supplier_type'] as String?,
      dataBytes: (json['data_amount'] as num?)?.toInt(),
      dataDisplay: json['data_display'] as String?,
      validityDays: (json['validity_days'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      orderStatus: json['order_status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      failedAt: json['failed_at'] == null
          ? null
          : DateTime.parse(json['failed_at'] as String),
      failureReason: json['failure_reason'] as String?,
    );

Map<String, dynamic> _$$RechargeOrderImplToJson(_$RechargeOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderNo,
      'iccid': instance.iccid,
      'plan_name': instance.planName,
      'package_code': instance.packageCode,
      'supplier_type': instance.supplierType,
      'data_amount': instance.dataBytes,
      'data_display': instance.dataDisplay,
      'validity_days': instance.validityDays,
      'amount': instance.amount,
      'currency': instance.currency,
      'order_status': instance.orderStatus,
      'payment_status': instance.paymentStatus,
      'created_at': instance.createdAt?.toIso8601String(),
      'paid_at': instance.paidAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'failed_at': instance.failedAt?.toIso8601String(),
      'failure_reason': instance.failureReason,
    };
