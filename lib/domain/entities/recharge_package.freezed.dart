// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recharge_package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RechargePackage _$RechargePackageFromJson(Map<String, dynamic> json) {
  return _RechargePackage.fromJson(json);
}

/// @nodoc
mixin _$RechargePackage {
  @JsonKey(name: 'package_code')
  String get packageCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_amount')
  int? get dataBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'validity_days')
  int? get validityDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration')
  int? get duration => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_unit')
  String? get durationUnit => throw _privateConstructorUsedError;

  /// 'pccw' | 'esimaccess' — required when creating a recharge order so
  /// the admin portal knows which supplier template to snapshot.
  @JsonKey(name: 'supplier_type')
  String get supplierType => throw _privateConstructorUsedError;

  /// Internal bookkeeping reference — not surfaced in UI.
  @JsonKey(name: 'package_source')
  String? get packageSource => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_code')
  String? get locationCode => throw _privateConstructorUsedError;

  /// Serializes this RechargePackage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RechargePackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RechargePackageCopyWith<RechargePackage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RechargePackageCopyWith<$Res> {
  factory $RechargePackageCopyWith(
    RechargePackage value,
    $Res Function(RechargePackage) then,
  ) = _$RechargePackageCopyWithImpl<$Res, RechargePackage>;
  @useResult
  $Res call({
    @JsonKey(name: 'package_code') String packageCode,
    String name,
    double price,
    String currency,
    @JsonKey(name: 'data_amount') int? dataBytes,
    @JsonKey(name: 'validity_days') int? validityDays,
    @JsonKey(name: 'duration') int? duration,
    @JsonKey(name: 'duration_unit') String? durationUnit,
    @JsonKey(name: 'supplier_type') String supplierType,
    @JsonKey(name: 'package_source') String? packageSource,
    @JsonKey(name: 'location_code') String? locationCode,
  });
}

/// @nodoc
class _$RechargePackageCopyWithImpl<$Res, $Val extends RechargePackage>
    implements $RechargePackageCopyWith<$Res> {
  _$RechargePackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RechargePackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageCode = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? dataBytes = freezed,
    Object? validityDays = freezed,
    Object? duration = freezed,
    Object? durationUnit = freezed,
    Object? supplierType = null,
    Object? packageSource = freezed,
    Object? locationCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            packageCode: null == packageCode
                ? _value.packageCode
                : packageCode // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            dataBytes: freezed == dataBytes
                ? _value.dataBytes
                : dataBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            validityDays: freezed == validityDays
                ? _value.validityDays
                : validityDays // ignore: cast_nullable_to_non_nullable
                      as int?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            durationUnit: freezed == durationUnit
                ? _value.durationUnit
                : durationUnit // ignore: cast_nullable_to_non_nullable
                      as String?,
            supplierType: null == supplierType
                ? _value.supplierType
                : supplierType // ignore: cast_nullable_to_non_nullable
                      as String,
            packageSource: freezed == packageSource
                ? _value.packageSource
                : packageSource // ignore: cast_nullable_to_non_nullable
                      as String?,
            locationCode: freezed == locationCode
                ? _value.locationCode
                : locationCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RechargePackageImplCopyWith<$Res>
    implements $RechargePackageCopyWith<$Res> {
  factory _$$RechargePackageImplCopyWith(
    _$RechargePackageImpl value,
    $Res Function(_$RechargePackageImpl) then,
  ) = __$$RechargePackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'package_code') String packageCode,
    String name,
    double price,
    String currency,
    @JsonKey(name: 'data_amount') int? dataBytes,
    @JsonKey(name: 'validity_days') int? validityDays,
    @JsonKey(name: 'duration') int? duration,
    @JsonKey(name: 'duration_unit') String? durationUnit,
    @JsonKey(name: 'supplier_type') String supplierType,
    @JsonKey(name: 'package_source') String? packageSource,
    @JsonKey(name: 'location_code') String? locationCode,
  });
}

/// @nodoc
class __$$RechargePackageImplCopyWithImpl<$Res>
    extends _$RechargePackageCopyWithImpl<$Res, _$RechargePackageImpl>
    implements _$$RechargePackageImplCopyWith<$Res> {
  __$$RechargePackageImplCopyWithImpl(
    _$RechargePackageImpl _value,
    $Res Function(_$RechargePackageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RechargePackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageCode = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? dataBytes = freezed,
    Object? validityDays = freezed,
    Object? duration = freezed,
    Object? durationUnit = freezed,
    Object? supplierType = null,
    Object? packageSource = freezed,
    Object? locationCode = freezed,
  }) {
    return _then(
      _$RechargePackageImpl(
        packageCode: null == packageCode
            ? _value.packageCode
            : packageCode // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        dataBytes: freezed == dataBytes
            ? _value.dataBytes
            : dataBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        validityDays: freezed == validityDays
            ? _value.validityDays
            : validityDays // ignore: cast_nullable_to_non_nullable
                  as int?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        durationUnit: freezed == durationUnit
            ? _value.durationUnit
            : durationUnit // ignore: cast_nullable_to_non_nullable
                  as String?,
        supplierType: null == supplierType
            ? _value.supplierType
            : supplierType // ignore: cast_nullable_to_non_nullable
                  as String,
        packageSource: freezed == packageSource
            ? _value.packageSource
            : packageSource // ignore: cast_nullable_to_non_nullable
                  as String?,
        locationCode: freezed == locationCode
            ? _value.locationCode
            : locationCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RechargePackageImpl extends _RechargePackage {
  const _$RechargePackageImpl({
    @JsonKey(name: 'package_code') required this.packageCode,
    required this.name,
    required this.price,
    this.currency = 'USD',
    @JsonKey(name: 'data_amount') this.dataBytes,
    @JsonKey(name: 'validity_days') this.validityDays,
    @JsonKey(name: 'duration') this.duration,
    @JsonKey(name: 'duration_unit') this.durationUnit,
    @JsonKey(name: 'supplier_type') this.supplierType = 'pccw',
    @JsonKey(name: 'package_source') this.packageSource,
    @JsonKey(name: 'location_code') this.locationCode,
  }) : super._();

  factory _$RechargePackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$RechargePackageImplFromJson(json);

  @override
  @JsonKey(name: 'package_code')
  final String packageCode;
  @override
  final String name;
  @override
  final double price;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'data_amount')
  final int? dataBytes;
  @override
  @JsonKey(name: 'validity_days')
  final int? validityDays;
  @override
  @JsonKey(name: 'duration')
  final int? duration;
  @override
  @JsonKey(name: 'duration_unit')
  final String? durationUnit;

  /// 'pccw' | 'esimaccess' — required when creating a recharge order so
  /// the admin portal knows which supplier template to snapshot.
  @override
  @JsonKey(name: 'supplier_type')
  final String supplierType;

  /// Internal bookkeeping reference — not surfaced in UI.
  @override
  @JsonKey(name: 'package_source')
  final String? packageSource;
  @override
  @JsonKey(name: 'location_code')
  final String? locationCode;

  @override
  String toString() {
    return 'RechargePackage(packageCode: $packageCode, name: $name, price: $price, currency: $currency, dataBytes: $dataBytes, validityDays: $validityDays, duration: $duration, durationUnit: $durationUnit, supplierType: $supplierType, packageSource: $packageSource, locationCode: $locationCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RechargePackageImpl &&
            (identical(other.packageCode, packageCode) ||
                other.packageCode == packageCode) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.dataBytes, dataBytes) ||
                other.dataBytes == dataBytes) &&
            (identical(other.validityDays, validityDays) ||
                other.validityDays == validityDays) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.durationUnit, durationUnit) ||
                other.durationUnit == durationUnit) &&
            (identical(other.supplierType, supplierType) ||
                other.supplierType == supplierType) &&
            (identical(other.packageSource, packageSource) ||
                other.packageSource == packageSource) &&
            (identical(other.locationCode, locationCode) ||
                other.locationCode == locationCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    packageCode,
    name,
    price,
    currency,
    dataBytes,
    validityDays,
    duration,
    durationUnit,
    supplierType,
    packageSource,
    locationCode,
  );

  /// Create a copy of RechargePackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RechargePackageImplCopyWith<_$RechargePackageImpl> get copyWith =>
      __$$RechargePackageImplCopyWithImpl<_$RechargePackageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RechargePackageImplToJson(this);
  }
}

abstract class _RechargePackage extends RechargePackage {
  const factory _RechargePackage({
    @JsonKey(name: 'package_code') required final String packageCode,
    required final String name,
    required final double price,
    final String currency,
    @JsonKey(name: 'data_amount') final int? dataBytes,
    @JsonKey(name: 'validity_days') final int? validityDays,
    @JsonKey(name: 'duration') final int? duration,
    @JsonKey(name: 'duration_unit') final String? durationUnit,
    @JsonKey(name: 'supplier_type') final String supplierType,
    @JsonKey(name: 'package_source') final String? packageSource,
    @JsonKey(name: 'location_code') final String? locationCode,
  }) = _$RechargePackageImpl;
  const _RechargePackage._() : super._();

  factory _RechargePackage.fromJson(Map<String, dynamic> json) =
      _$RechargePackageImpl.fromJson;

  @override
  @JsonKey(name: 'package_code')
  String get packageCode;
  @override
  String get name;
  @override
  double get price;
  @override
  String get currency;
  @override
  @JsonKey(name: 'data_amount')
  int? get dataBytes;
  @override
  @JsonKey(name: 'validity_days')
  int? get validityDays;
  @override
  @JsonKey(name: 'duration')
  int? get duration;
  @override
  @JsonKey(name: 'duration_unit')
  String? get durationUnit;

  /// 'pccw' | 'esimaccess' — required when creating a recharge order so
  /// the admin portal knows which supplier template to snapshot.
  @override
  @JsonKey(name: 'supplier_type')
  String get supplierType;

  /// Internal bookkeeping reference — not surfaced in UI.
  @override
  @JsonKey(name: 'package_source')
  String? get packageSource;
  @override
  @JsonKey(name: 'location_code')
  String? get locationCode;

  /// Create a copy of RechargePackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RechargePackageImplCopyWith<_$RechargePackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
