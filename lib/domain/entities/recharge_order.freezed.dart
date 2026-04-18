// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recharge_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RechargeOrder _$RechargeOrderFromJson(Map<String, dynamic> json) {
  return _RechargeOrder.fromJson(json);
}

/// @nodoc
mixin _$RechargeOrder {
  int get id => throw _privateConstructorUsedError;

  /// Public-facing order number, e.g. `RCHG-20260418-000123`.
  @JsonKey(name: 'order_id')
  String? get orderNo => throw _privateConstructorUsedError;
  String? get iccid => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_name')
  String? get planName => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_code')
  String? get packageCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_type')
  String? get supplierType => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_amount')
  int? get dataBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_display')
  String? get dataDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'validity_days')
  int? get validityDays => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_status')
  String? get orderStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'failed_at')
  DateTime? get failedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'failure_reason')
  String? get failureReason => throw _privateConstructorUsedError;

  /// Serializes this RechargeOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RechargeOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RechargeOrderCopyWith<RechargeOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RechargeOrderCopyWith<$Res> {
  factory $RechargeOrderCopyWith(
    RechargeOrder value,
    $Res Function(RechargeOrder) then,
  ) = _$RechargeOrderCopyWithImpl<$Res, RechargeOrder>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'order_id') String? orderNo,
    String? iccid,
    @JsonKey(name: 'plan_name') String? planName,
    @JsonKey(name: 'package_code') String? packageCode,
    @JsonKey(name: 'supplier_type') String? supplierType,
    @JsonKey(name: 'data_amount') int? dataBytes,
    @JsonKey(name: 'data_display') String? dataDisplay,
    @JsonKey(name: 'validity_days') int? validityDays,
    double amount,
    String currency,
    @JsonKey(name: 'order_status') String? orderStatus,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'failed_at') DateTime? failedAt,
    @JsonKey(name: 'failure_reason') String? failureReason,
  });
}

/// @nodoc
class _$RechargeOrderCopyWithImpl<$Res, $Val extends RechargeOrder>
    implements $RechargeOrderCopyWith<$Res> {
  _$RechargeOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RechargeOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNo = freezed,
    Object? iccid = freezed,
    Object? planName = freezed,
    Object? packageCode = freezed,
    Object? supplierType = freezed,
    Object? dataBytes = freezed,
    Object? dataDisplay = freezed,
    Object? validityDays = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? orderStatus = freezed,
    Object? paymentStatus = freezed,
    Object? createdAt = freezed,
    Object? paidAt = freezed,
    Object? completedAt = freezed,
    Object? failedAt = freezed,
    Object? failureReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            orderNo: freezed == orderNo
                ? _value.orderNo
                : orderNo // ignore: cast_nullable_to_non_nullable
                      as String?,
            iccid: freezed == iccid
                ? _value.iccid
                : iccid // ignore: cast_nullable_to_non_nullable
                      as String?,
            planName: freezed == planName
                ? _value.planName
                : planName // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageCode: freezed == packageCode
                ? _value.packageCode
                : packageCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            supplierType: freezed == supplierType
                ? _value.supplierType
                : supplierType // ignore: cast_nullable_to_non_nullable
                      as String?,
            dataBytes: freezed == dataBytes
                ? _value.dataBytes
                : dataBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            dataDisplay: freezed == dataDisplay
                ? _value.dataDisplay
                : dataDisplay // ignore: cast_nullable_to_non_nullable
                      as String?,
            validityDays: freezed == validityDays
                ? _value.validityDays
                : validityDays // ignore: cast_nullable_to_non_nullable
                      as int?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            orderStatus: freezed == orderStatus
                ? _value.orderStatus
                : orderStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            failedAt: freezed == failedAt
                ? _value.failedAt
                : failedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            failureReason: freezed == failureReason
                ? _value.failureReason
                : failureReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RechargeOrderImplCopyWith<$Res>
    implements $RechargeOrderCopyWith<$Res> {
  factory _$$RechargeOrderImplCopyWith(
    _$RechargeOrderImpl value,
    $Res Function(_$RechargeOrderImpl) then,
  ) = __$$RechargeOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'order_id') String? orderNo,
    String? iccid,
    @JsonKey(name: 'plan_name') String? planName,
    @JsonKey(name: 'package_code') String? packageCode,
    @JsonKey(name: 'supplier_type') String? supplierType,
    @JsonKey(name: 'data_amount') int? dataBytes,
    @JsonKey(name: 'data_display') String? dataDisplay,
    @JsonKey(name: 'validity_days') int? validityDays,
    double amount,
    String currency,
    @JsonKey(name: 'order_status') String? orderStatus,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'failed_at') DateTime? failedAt,
    @JsonKey(name: 'failure_reason') String? failureReason,
  });
}

/// @nodoc
class __$$RechargeOrderImplCopyWithImpl<$Res>
    extends _$RechargeOrderCopyWithImpl<$Res, _$RechargeOrderImpl>
    implements _$$RechargeOrderImplCopyWith<$Res> {
  __$$RechargeOrderImplCopyWithImpl(
    _$RechargeOrderImpl _value,
    $Res Function(_$RechargeOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RechargeOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNo = freezed,
    Object? iccid = freezed,
    Object? planName = freezed,
    Object? packageCode = freezed,
    Object? supplierType = freezed,
    Object? dataBytes = freezed,
    Object? dataDisplay = freezed,
    Object? validityDays = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? orderStatus = freezed,
    Object? paymentStatus = freezed,
    Object? createdAt = freezed,
    Object? paidAt = freezed,
    Object? completedAt = freezed,
    Object? failedAt = freezed,
    Object? failureReason = freezed,
  }) {
    return _then(
      _$RechargeOrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        orderNo: freezed == orderNo
            ? _value.orderNo
            : orderNo // ignore: cast_nullable_to_non_nullable
                  as String?,
        iccid: freezed == iccid
            ? _value.iccid
            : iccid // ignore: cast_nullable_to_non_nullable
                  as String?,
        planName: freezed == planName
            ? _value.planName
            : planName // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageCode: freezed == packageCode
            ? _value.packageCode
            : packageCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        supplierType: freezed == supplierType
            ? _value.supplierType
            : supplierType // ignore: cast_nullable_to_non_nullable
                  as String?,
        dataBytes: freezed == dataBytes
            ? _value.dataBytes
            : dataBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        dataDisplay: freezed == dataDisplay
            ? _value.dataDisplay
            : dataDisplay // ignore: cast_nullable_to_non_nullable
                  as String?,
        validityDays: freezed == validityDays
            ? _value.validityDays
            : validityDays // ignore: cast_nullable_to_non_nullable
                  as int?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        orderStatus: freezed == orderStatus
            ? _value.orderStatus
            : orderStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        failedAt: freezed == failedAt
            ? _value.failedAt
            : failedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        failureReason: freezed == failureReason
            ? _value.failureReason
            : failureReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RechargeOrderImpl extends _RechargeOrder {
  const _$RechargeOrderImpl({
    required this.id,
    @JsonKey(name: 'order_id') this.orderNo,
    this.iccid,
    @JsonKey(name: 'plan_name') this.planName,
    @JsonKey(name: 'package_code') this.packageCode,
    @JsonKey(name: 'supplier_type') this.supplierType,
    @JsonKey(name: 'data_amount') this.dataBytes,
    @JsonKey(name: 'data_display') this.dataDisplay,
    @JsonKey(name: 'validity_days') this.validityDays,
    this.amount = 0.0,
    this.currency = 'USD',
    @JsonKey(name: 'order_status') this.orderStatus,
    @JsonKey(name: 'payment_status') this.paymentStatus,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'paid_at') this.paidAt,
    @JsonKey(name: 'completed_at') this.completedAt,
    @JsonKey(name: 'failed_at') this.failedAt,
    @JsonKey(name: 'failure_reason') this.failureReason,
  }) : super._();

  factory _$RechargeOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$RechargeOrderImplFromJson(json);

  @override
  final int id;

  /// Public-facing order number, e.g. `RCHG-20260418-000123`.
  @override
  @JsonKey(name: 'order_id')
  final String? orderNo;
  @override
  final String? iccid;
  @override
  @JsonKey(name: 'plan_name')
  final String? planName;
  @override
  @JsonKey(name: 'package_code')
  final String? packageCode;
  @override
  @JsonKey(name: 'supplier_type')
  final String? supplierType;
  @override
  @JsonKey(name: 'data_amount')
  final int? dataBytes;
  @override
  @JsonKey(name: 'data_display')
  final String? dataDisplay;
  @override
  @JsonKey(name: 'validity_days')
  final int? validityDays;
  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'order_status')
  final String? orderStatus;
  @override
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'failed_at')
  final DateTime? failedAt;
  @override
  @JsonKey(name: 'failure_reason')
  final String? failureReason;

  @override
  String toString() {
    return 'RechargeOrder(id: $id, orderNo: $orderNo, iccid: $iccid, planName: $planName, packageCode: $packageCode, supplierType: $supplierType, dataBytes: $dataBytes, dataDisplay: $dataDisplay, validityDays: $validityDays, amount: $amount, currency: $currency, orderStatus: $orderStatus, paymentStatus: $paymentStatus, createdAt: $createdAt, paidAt: $paidAt, completedAt: $completedAt, failedAt: $failedAt, failureReason: $failureReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RechargeOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.iccid, iccid) || other.iccid == iccid) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.packageCode, packageCode) ||
                other.packageCode == packageCode) &&
            (identical(other.supplierType, supplierType) ||
                other.supplierType == supplierType) &&
            (identical(other.dataBytes, dataBytes) ||
                other.dataBytes == dataBytes) &&
            (identical(other.dataDisplay, dataDisplay) ||
                other.dataDisplay == dataDisplay) &&
            (identical(other.validityDays, validityDays) ||
                other.validityDays == validityDays) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.orderStatus, orderStatus) ||
                other.orderStatus == orderStatus) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.failedAt, failedAt) ||
                other.failedAt == failedAt) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderNo,
    iccid,
    planName,
    packageCode,
    supplierType,
    dataBytes,
    dataDisplay,
    validityDays,
    amount,
    currency,
    orderStatus,
    paymentStatus,
    createdAt,
    paidAt,
    completedAt,
    failedAt,
    failureReason,
  );

  /// Create a copy of RechargeOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RechargeOrderImplCopyWith<_$RechargeOrderImpl> get copyWith =>
      __$$RechargeOrderImplCopyWithImpl<_$RechargeOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RechargeOrderImplToJson(this);
  }
}

abstract class _RechargeOrder extends RechargeOrder {
  const factory _RechargeOrder({
    required final int id,
    @JsonKey(name: 'order_id') final String? orderNo,
    final String? iccid,
    @JsonKey(name: 'plan_name') final String? planName,
    @JsonKey(name: 'package_code') final String? packageCode,
    @JsonKey(name: 'supplier_type') final String? supplierType,
    @JsonKey(name: 'data_amount') final int? dataBytes,
    @JsonKey(name: 'data_display') final String? dataDisplay,
    @JsonKey(name: 'validity_days') final int? validityDays,
    final double amount,
    final String currency,
    @JsonKey(name: 'order_status') final String? orderStatus,
    @JsonKey(name: 'payment_status') final String? paymentStatus,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'paid_at') final DateTime? paidAt,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    @JsonKey(name: 'failed_at') final DateTime? failedAt,
    @JsonKey(name: 'failure_reason') final String? failureReason,
  }) = _$RechargeOrderImpl;
  const _RechargeOrder._() : super._();

  factory _RechargeOrder.fromJson(Map<String, dynamic> json) =
      _$RechargeOrderImpl.fromJson;

  @override
  int get id;

  /// Public-facing order number, e.g. `RCHG-20260418-000123`.
  @override
  @JsonKey(name: 'order_id')
  String? get orderNo;
  @override
  String? get iccid;
  @override
  @JsonKey(name: 'plan_name')
  String? get planName;
  @override
  @JsonKey(name: 'package_code')
  String? get packageCode;
  @override
  @JsonKey(name: 'supplier_type')
  String? get supplierType;
  @override
  @JsonKey(name: 'data_amount')
  int? get dataBytes;
  @override
  @JsonKey(name: 'data_display')
  String? get dataDisplay;
  @override
  @JsonKey(name: 'validity_days')
  int? get validityDays;
  @override
  double get amount;
  @override
  String get currency;
  @override
  @JsonKey(name: 'order_status')
  String? get orderStatus;
  @override
  @JsonKey(name: 'payment_status')
  String? get paymentStatus;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'failed_at')
  DateTime? get failedAt;
  @override
  @JsonKey(name: 'failure_reason')
  String? get failureReason;

  /// Create a copy of RechargeOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RechargeOrderImplCopyWith<_$RechargeOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
