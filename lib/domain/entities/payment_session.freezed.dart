// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentSession _$PaymentSessionFromJson(Map<String, dynamic> json) {
  return _PaymentSession.fromJson(json);
}

/// @nodoc
mixin _$PaymentSession {
  @JsonKey(name: 'order_no')
  String get orderNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_intent_id')
  String get paymentIntentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_secret')
  String get clientSecret => throw _privateConstructorUsedError;
  String? get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this PaymentSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentSessionCopyWith<PaymentSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentSessionCopyWith<$Res> {
  factory $PaymentSessionCopyWith(
    PaymentSession value,
    $Res Function(PaymentSession) then,
  ) = _$PaymentSessionCopyWithImpl<$Res, PaymentSession>;
  @useResult
  $Res call({
    @JsonKey(name: 'order_no') String orderNo,
    @JsonKey(name: 'payment_intent_id') String paymentIntentId,
    @JsonKey(name: 'client_secret') String clientSecret,
    String? amount,
    String currency,
  });
}

/// @nodoc
class _$PaymentSessionCopyWithImpl<$Res, $Val extends PaymentSession>
    implements $PaymentSessionCopyWith<$Res> {
  _$PaymentSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNo = null,
    Object? paymentIntentId = null,
    Object? clientSecret = null,
    Object? amount = freezed,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            orderNo: null == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentIntentId: null == paymentIntentId
                ? _value.paymentIntentId
                : paymentIntentId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientSecret: null == clientSecret
                ? _value.clientSecret
                : clientSecret // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as String?,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentSessionImplCopyWith<$Res>
    implements $PaymentSessionCopyWith<$Res> {
  factory _$$PaymentSessionImplCopyWith(
    _$PaymentSessionImpl value,
    $Res Function(_$PaymentSessionImpl) then,
  ) = __$$PaymentSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'order_no') String orderNo,
    @JsonKey(name: 'payment_intent_id') String paymentIntentId,
    @JsonKey(name: 'client_secret') String clientSecret,
    String? amount,
    String currency,
  });
}

/// @nodoc
class __$$PaymentSessionImplCopyWithImpl<$Res>
    extends _$PaymentSessionCopyWithImpl<$Res, _$PaymentSessionImpl>
    implements _$$PaymentSessionImplCopyWith<$Res> {
  __$$PaymentSessionImplCopyWithImpl(
    _$PaymentSessionImpl _value,
    $Res Function(_$PaymentSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNo = null,
    Object? paymentIntentId = null,
    Object? clientSecret = null,
    Object? amount = freezed,
    Object? currency = null,
  }) {
    return _then(
      _$PaymentSessionImpl(
        orderNo: null == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentIntentId: null == paymentIntentId
            ? _value.paymentIntentId
            : paymentIntentId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientSecret: null == clientSecret
            ? _value.clientSecret
            : clientSecret // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as String?,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentSessionImpl implements _PaymentSession {
  const _$PaymentSessionImpl({
    @JsonKey(name: 'order_no') required this.orderNo,
    @JsonKey(name: 'payment_intent_id') required this.paymentIntentId,
    @JsonKey(name: 'client_secret') required this.clientSecret,
    this.amount,
    this.currency = 'USD',
  });

  factory _$PaymentSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentSessionImplFromJson(json);

  @override
  @JsonKey(name: 'order_no')
  final String orderNo;
  @override
  @JsonKey(name: 'payment_intent_id')
  final String paymentIntentId;
  @override
  @JsonKey(name: 'client_secret')
  final String clientSecret;
  @override
  final String? amount;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'PaymentSession(orderNo: $orderNo, paymentIntentId: $paymentIntentId, clientSecret: $clientSecret, amount: $amount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSessionImpl &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderNo,
    paymentIntentId,
    clientSecret,
    amount,
    currency,
  );

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSessionImplCopyWith<_$PaymentSessionImpl> get copyWith =>
      __$$PaymentSessionImplCopyWithImpl<_$PaymentSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentSessionImplToJson(this);
  }
}

abstract class _PaymentSession implements PaymentSession {
  const factory _PaymentSession({
    @JsonKey(name: 'order_no') required final String orderNo,
    @JsonKey(name: 'payment_intent_id') required final String paymentIntentId,
    @JsonKey(name: 'client_secret') required final String clientSecret,
    final String? amount,
    final String currency,
  }) = _$PaymentSessionImpl;

  factory _PaymentSession.fromJson(Map<String, dynamic> json) =
      _$PaymentSessionImpl.fromJson;

  @override
  @JsonKey(name: 'order_no')
  String get orderNo;
  @override
  @JsonKey(name: 'payment_intent_id')
  String get paymentIntentId;
  @override
  @JsonKey(name: 'client_secret')
  String get clientSecret;
  @override
  String? get amount;
  @override
  String get currency;

  /// Create a copy of PaymentSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentSessionImplCopyWith<_$PaymentSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
