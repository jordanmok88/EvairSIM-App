// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentIntent _$PaymentIntentFromJson(Map<String, dynamic> json) {
  return _PaymentIntent.fromJson(json);
}

/// @nodoc
mixin _$PaymentIntent {
  @JsonKey(name: 'client_secret')
  String? get clientSecret => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_intent_id')
  String? get paymentIntentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'publishable_key')
  String? get publishableKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount')
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'redirect_url')
  String? get redirectUrl => throw _privateConstructorUsedError;

  /// Serializes this PaymentIntent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentIntentCopyWith<PaymentIntent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentIntentCopyWith<$Res> {
  factory $PaymentIntentCopyWith(
    PaymentIntent value,
    $Res Function(PaymentIntent) then,
  ) = _$PaymentIntentCopyWithImpl<$Res, PaymentIntent>;
  @useResult
  $Res call({
    @JsonKey(name: 'client_secret') String? clientSecret,
    @JsonKey(name: 'payment_intent_id') String? paymentIntentId,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'publishable_key') String? publishableKey,
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'currency') String? currency,
    @JsonKey(name: 'redirect_url') String? redirectUrl,
  });
}

/// @nodoc
class _$PaymentIntentCopyWithImpl<$Res, $Val extends PaymentIntent>
    implements $PaymentIntentCopyWith<$Res> {
  _$PaymentIntentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientSecret = freezed,
    Object? paymentIntentId = freezed,
    Object? paymentMethod = freezed,
    Object? publishableKey = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? redirectUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            clientSecret: freezed == clientSecret
                ? _value.clientSecret
                : clientSecret // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentIntentId: freezed == paymentIntentId
                ? _value.paymentIntentId
                : paymentIntentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            publishableKey: freezed == publishableKey
                ? _value.publishableKey
                : publishableKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            currency: freezed == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String?,
            redirectUrl: freezed == redirectUrl
                ? _value.redirectUrl
                : redirectUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentIntentImplCopyWith<$Res>
    implements $PaymentIntentCopyWith<$Res> {
  factory _$$PaymentIntentImplCopyWith(
    _$PaymentIntentImpl value,
    $Res Function(_$PaymentIntentImpl) then,
  ) = __$$PaymentIntentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'client_secret') String? clientSecret,
    @JsonKey(name: 'payment_intent_id') String? paymentIntentId,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'publishable_key') String? publishableKey,
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'currency') String? currency,
    @JsonKey(name: 'redirect_url') String? redirectUrl,
  });
}

/// @nodoc
class __$$PaymentIntentImplCopyWithImpl<$Res>
    extends _$PaymentIntentCopyWithImpl<$Res, _$PaymentIntentImpl>
    implements _$$PaymentIntentImplCopyWith<$Res> {
  __$$PaymentIntentImplCopyWithImpl(
    _$PaymentIntentImpl _value,
    $Res Function(_$PaymentIntentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientSecret = freezed,
    Object? paymentIntentId = freezed,
    Object? paymentMethod = freezed,
    Object? publishableKey = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? redirectUrl = freezed,
  }) {
    return _then(
      _$PaymentIntentImpl(
        clientSecret: freezed == clientSecret
            ? _value.clientSecret
            : clientSecret // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentIntentId: freezed == paymentIntentId
            ? _value.paymentIntentId
            : paymentIntentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        publishableKey: freezed == publishableKey
            ? _value.publishableKey
            : publishableKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        currency: freezed == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
        redirectUrl: freezed == redirectUrl
            ? _value.redirectUrl
            : redirectUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentIntentImpl implements _PaymentIntent {
  const _$PaymentIntentImpl({
    @JsonKey(name: 'client_secret') this.clientSecret,
    @JsonKey(name: 'payment_intent_id') this.paymentIntentId,
    @JsonKey(name: 'payment_method') this.paymentMethod,
    @JsonKey(name: 'publishable_key') this.publishableKey,
    @JsonKey(name: 'amount') this.amount,
    @JsonKey(name: 'currency') this.currency,
    @JsonKey(name: 'redirect_url') this.redirectUrl,
  });

  factory _$PaymentIntentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentIntentImplFromJson(json);

  @override
  @JsonKey(name: 'client_secret')
  final String? clientSecret;
  @override
  @JsonKey(name: 'payment_intent_id')
  final String? paymentIntentId;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  @JsonKey(name: 'publishable_key')
  final String? publishableKey;
  @override
  @JsonKey(name: 'amount')
  final double? amount;
  @override
  @JsonKey(name: 'currency')
  final String? currency;
  @override
  @JsonKey(name: 'redirect_url')
  final String? redirectUrl;

  @override
  String toString() {
    return 'PaymentIntent(clientSecret: $clientSecret, paymentIntentId: $paymentIntentId, paymentMethod: $paymentMethod, publishableKey: $publishableKey, amount: $amount, currency: $currency, redirectUrl: $redirectUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentIntentImpl &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.publishableKey, publishableKey) ||
                other.publishableKey == publishableKey) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.redirectUrl, redirectUrl) ||
                other.redirectUrl == redirectUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    clientSecret,
    paymentIntentId,
    paymentMethod,
    publishableKey,
    amount,
    currency,
    redirectUrl,
  );

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentIntentImplCopyWith<_$PaymentIntentImpl> get copyWith =>
      __$$PaymentIntentImplCopyWithImpl<_$PaymentIntentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentIntentImplToJson(this);
  }
}

abstract class _PaymentIntent implements PaymentIntent {
  const factory _PaymentIntent({
    @JsonKey(name: 'client_secret') final String? clientSecret,
    @JsonKey(name: 'payment_intent_id') final String? paymentIntentId,
    @JsonKey(name: 'payment_method') final String? paymentMethod,
    @JsonKey(name: 'publishable_key') final String? publishableKey,
    @JsonKey(name: 'amount') final double? amount,
    @JsonKey(name: 'currency') final String? currency,
    @JsonKey(name: 'redirect_url') final String? redirectUrl,
  }) = _$PaymentIntentImpl;

  factory _PaymentIntent.fromJson(Map<String, dynamic> json) =
      _$PaymentIntentImpl.fromJson;

  @override
  @JsonKey(name: 'client_secret')
  String? get clientSecret;
  @override
  @JsonKey(name: 'payment_intent_id')
  String? get paymentIntentId;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  @JsonKey(name: 'publishable_key')
  String? get publishableKey;
  @override
  @JsonKey(name: 'amount')
  double? get amount;
  @override
  @JsonKey(name: 'currency')
  String? get currency;
  @override
  @JsonKey(name: 'redirect_url')
  String? get redirectUrl;

  /// Create a copy of PaymentIntent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentIntentImplCopyWith<_$PaymentIntentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
