import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_intent.freezed.dart';
part 'payment_intent.g.dart';

/// Return shape of `POST /v1/app/recharge/{id}/pay`. The backend runs the
/// Stripe `PaymentIntent` and hands us the `client_secret` to confirm on
/// the client side.
///
/// We deliberately keep this minimal — advanced fields (refund IDs,
/// gateway-specific metadata) stay server-side.
@freezed
class PaymentIntent with _$PaymentIntent {
  const factory PaymentIntent({
    @JsonKey(name: 'client_secret') String? clientSecret,
    @JsonKey(name: 'payment_intent_id') String? paymentIntentId,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'publishable_key') String? publishableKey,
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'currency') String? currency,
    @JsonKey(name: 'redirect_url') String? redirectUrl,
  }) = _PaymentIntent;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentFromJson(json);
}
