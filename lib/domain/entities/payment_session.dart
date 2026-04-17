import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_session.freezed.dart';
part 'payment_session.g.dart';

/// Stripe payment intent info returned by POST /v1/h5/payments/create.
@freezed
class PaymentSession with _$PaymentSession {
  const factory PaymentSession({
    @JsonKey(name: 'order_no') required String orderNo,
    @JsonKey(name: 'payment_intent_id') required String paymentIntentId,
    @JsonKey(name: 'client_secret') required String clientSecret,
    String? amount,
    @Default('USD') String currency,
  }) = _PaymentSession;

  factory PaymentSession.fromJson(Map<String, dynamic> json) =>
      _$PaymentSessionFromJson(json);
}
