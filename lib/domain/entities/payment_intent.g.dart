// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentIntentImpl _$$PaymentIntentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentIntentImpl(
      clientSecret: json['client_secret'] as String?,
      paymentIntentId: json['payment_intent_id'] as String?,
      paymentMethod: json['payment_method'] as String?,
      publishableKey: json['publishable_key'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      redirectUrl: json['redirect_url'] as String?,
    );

Map<String, dynamic> _$$PaymentIntentImplToJson(_$PaymentIntentImpl instance) =>
    <String, dynamic>{
      'client_secret': instance.clientSecret,
      'payment_intent_id': instance.paymentIntentId,
      'payment_method': instance.paymentMethod,
      'publishable_key': instance.publishableKey,
      'amount': instance.amount,
      'currency': instance.currency,
      'redirect_url': instance.redirectUrl,
    };
