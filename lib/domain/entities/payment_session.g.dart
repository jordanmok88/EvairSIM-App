// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentSessionImpl _$$PaymentSessionImplFromJson(Map<String, dynamic> json) =>
    _$PaymentSessionImpl(
      orderNo: json['order_no'] as String,
      paymentIntentId: json['payment_intent_id'] as String,
      clientSecret: json['client_secret'] as String,
      amount: json['amount'] as String?,
      currency: json['currency'] as String? ?? 'USD',
    );

Map<String, dynamic> _$$PaymentSessionImplToJson(
  _$PaymentSessionImpl instance,
) => <String, dynamic>{
  'order_no': instance.orderNo,
  'payment_intent_id': instance.paymentIntentId,
  'client_secret': instance.clientSecret,
  'amount': instance.amount,
  'currency': instance.currency,
};
