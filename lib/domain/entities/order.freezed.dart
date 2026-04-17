// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppOrder _$AppOrderFromJson(Map<String, dynamic> json) {
  return _AppOrder.fromJson(json);
}

/// @nodoc
mixin _$AppOrder {
  @JsonKey(name: 'order_no', readValue: _readOrderNo)
  String get orderNo => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readStatus)
  String get status => throw _privateConstructorUsedError;

  /// Amount in USD. Backend sometimes returns cents (int), sometimes decimal — we normalise to USD double.
  @JsonKey(readValue: _readAmount)
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_code')
  String? get packageCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_name')
  String? get packageName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt => throw _privateConstructorUsedError;

  /// Populated once the eSIM has been provisioned (usually after payment). This
  /// is the SM-DP+ activation string that we render as a QR code.
  @JsonKey(name: 'lpa_code', readValue: _readLpa)
  String? get lpaCode => throw _privateConstructorUsedError;

  /// ICCID of the eSIM that was allocated against this order — available on the
  /// order detail endpoint after provisioning completes.
  @JsonKey(name: 'iccid')
  String? get iccid => throw _privateConstructorUsedError;

  /// Serializes this AppOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppOrderCopyWith<AppOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppOrderCopyWith<$Res> {
  factory $AppOrderCopyWith(AppOrder value, $Res Function(AppOrder) then) =
      _$AppOrderCopyWithImpl<$Res, AppOrder>;
  @useResult
  $Res call({
    @JsonKey(name: 'order_no', readValue: _readOrderNo) String orderNo,
    @JsonKey(readValue: _readStatus) String status,
    @JsonKey(readValue: _readAmount) double amount,
    String currency,
    @JsonKey(name: 'package_code') String? packageCode,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'lpa_code', readValue: _readLpa) String? lpaCode,
    @JsonKey(name: 'iccid') String? iccid,
  });
}

/// @nodoc
class _$AppOrderCopyWithImpl<$Res, $Val extends AppOrder>
    implements $AppOrderCopyWith<$Res> {
  _$AppOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNo = null,
    Object? status = null,
    Object? amount = null,
    Object? currency = null,
    Object? packageCode = freezed,
    Object? packageName = freezed,
    Object? createdAt = freezed,
    Object? paidAt = freezed,
    Object? lpaCode = freezed,
    Object? iccid = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderNo: null == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            packageCode: freezed == packageCode
                ? _value.packageCode
                : packageCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageName: freezed == packageName
                ? _value.packageName
                : packageName // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lpaCode: freezed == lpaCode
                ? _value.lpaCode
                : lpaCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            iccid: freezed == iccid
                ? _value.iccid
                : iccid // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppOrderImplCopyWith<$Res>
    implements $AppOrderCopyWith<$Res> {
  factory _$$AppOrderImplCopyWith(
    _$AppOrderImpl value,
    $Res Function(_$AppOrderImpl) then,
  ) = __$$AppOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'order_no', readValue: _readOrderNo) String orderNo,
    @JsonKey(readValue: _readStatus) String status,
    @JsonKey(readValue: _readAmount) double amount,
    String currency,
    @JsonKey(name: 'package_code') String? packageCode,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'lpa_code', readValue: _readLpa) String? lpaCode,
    @JsonKey(name: 'iccid') String? iccid,
  });
}

/// @nodoc
class __$$AppOrderImplCopyWithImpl<$Res>
    extends _$AppOrderCopyWithImpl<$Res, _$AppOrderImpl>
    implements _$$AppOrderImplCopyWith<$Res> {
  __$$AppOrderImplCopyWithImpl(
    _$AppOrderImpl _value,
    $Res Function(_$AppOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNo = null,
    Object? status = null,
    Object? amount = null,
    Object? currency = null,
    Object? packageCode = freezed,
    Object? packageName = freezed,
    Object? createdAt = freezed,
    Object? paidAt = freezed,
    Object? lpaCode = freezed,
    Object? iccid = freezed,
  }) {
    return _then(
      _$AppOrderImpl(
        orderNo: null == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        packageCode: freezed == packageCode
            ? _value.packageCode
            : packageCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageName: freezed == packageName
            ? _value.packageName
            : packageName // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lpaCode: freezed == lpaCode
            ? _value.lpaCode
            : lpaCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        iccid: freezed == iccid
            ? _value.iccid
            : iccid // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppOrderImpl extends _AppOrder {
  const _$AppOrderImpl({
    @JsonKey(name: 'order_no', readValue: _readOrderNo) required this.orderNo,
    @JsonKey(readValue: _readStatus) required this.status,
    @JsonKey(readValue: _readAmount) required this.amount,
    this.currency = 'USD',
    @JsonKey(name: 'package_code') this.packageCode,
    @JsonKey(name: 'package_name') this.packageName,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'paid_at') this.paidAt,
    @JsonKey(name: 'lpa_code', readValue: _readLpa) this.lpaCode,
    @JsonKey(name: 'iccid') this.iccid,
  }) : super._();

  factory _$AppOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppOrderImplFromJson(json);

  @override
  @JsonKey(name: 'order_no', readValue: _readOrderNo)
  final String orderNo;
  @override
  @JsonKey(readValue: _readStatus)
  final String status;

  /// Amount in USD. Backend sometimes returns cents (int), sometimes decimal — we normalise to USD double.
  @override
  @JsonKey(readValue: _readAmount)
  final double amount;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'package_code')
  final String? packageCode;
  @override
  @JsonKey(name: 'package_name')
  final String? packageName;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;

  /// Populated once the eSIM has been provisioned (usually after payment). This
  /// is the SM-DP+ activation string that we render as a QR code.
  @override
  @JsonKey(name: 'lpa_code', readValue: _readLpa)
  final String? lpaCode;

  /// ICCID of the eSIM that was allocated against this order — available on the
  /// order detail endpoint after provisioning completes.
  @override
  @JsonKey(name: 'iccid')
  final String? iccid;

  @override
  String toString() {
    return 'AppOrder(orderNo: $orderNo, status: $status, amount: $amount, currency: $currency, packageCode: $packageCode, packageName: $packageName, createdAt: $createdAt, paidAt: $paidAt, lpaCode: $lpaCode, iccid: $iccid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppOrderImpl &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.packageCode, packageCode) ||
                other.packageCode == packageCode) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.lpaCode, lpaCode) || other.lpaCode == lpaCode) &&
            (identical(other.iccid, iccid) || other.iccid == iccid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderNo,
    status,
    amount,
    currency,
    packageCode,
    packageName,
    createdAt,
    paidAt,
    lpaCode,
    iccid,
  );

  /// Create a copy of AppOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppOrderImplCopyWith<_$AppOrderImpl> get copyWith =>
      __$$AppOrderImplCopyWithImpl<_$AppOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppOrderImplToJson(this);
  }
}

abstract class _AppOrder extends AppOrder {
  const factory _AppOrder({
    @JsonKey(name: 'order_no', readValue: _readOrderNo)
    required final String orderNo,
    @JsonKey(readValue: _readStatus) required final String status,
    @JsonKey(readValue: _readAmount) required final double amount,
    final String currency,
    @JsonKey(name: 'package_code') final String? packageCode,
    @JsonKey(name: 'package_name') final String? packageName,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'paid_at') final DateTime? paidAt,
    @JsonKey(name: 'lpa_code', readValue: _readLpa) final String? lpaCode,
    @JsonKey(name: 'iccid') final String? iccid,
  }) = _$AppOrderImpl;
  const _AppOrder._() : super._();

  factory _AppOrder.fromJson(Map<String, dynamic> json) =
      _$AppOrderImpl.fromJson;

  @override
  @JsonKey(name: 'order_no', readValue: _readOrderNo)
  String get orderNo;
  @override
  @JsonKey(readValue: _readStatus)
  String get status;

  /// Amount in USD. Backend sometimes returns cents (int), sometimes decimal — we normalise to USD double.
  @override
  @JsonKey(readValue: _readAmount)
  double get amount;
  @override
  String get currency;
  @override
  @JsonKey(name: 'package_code')
  String? get packageCode;
  @override
  @JsonKey(name: 'package_name')
  String? get packageName;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;

  /// Populated once the eSIM has been provisioned (usually after payment). This
  /// is the SM-DP+ activation string that we render as a QR code.
  @override
  @JsonKey(name: 'lpa_code', readValue: _readLpa)
  String? get lpaCode;

  /// ICCID of the eSIM that was allocated against this order — available on the
  /// order detail endpoint after provisioning completes.
  @override
  @JsonKey(name: 'iccid')
  String? get iccid;

  /// Create a copy of AppOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppOrderImplCopyWith<_$AppOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
