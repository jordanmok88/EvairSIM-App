// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sim.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Sim _$SimFromJson(Map<String, dynamic> json) {
  return _Sim.fromJson(json);
}

/// @nodoc
mixin _$Sim {
  String get iccid => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'package_name')
  String? get packageName => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_code')
  String? get countryCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_name')
  String? get countryName => throw _privateConstructorUsedError;

  /// Total data in bytes.
  @JsonKey(name: 'data_total_bytes')
  int? get totalBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_used_bytes')
  int? get usedBytes => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_remaining_bytes')
  int? get remainingBytes => throw _privateConstructorUsedError;

  /// ISO-8601 expiry timestamp.
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'activated_at')
  DateTime? get activatedAt => throw _privateConstructorUsedError;

  /// eSIM QR / LPA fields (only present for eSIMs).
  String? get qrcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'ac_code')
  String? get acCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'lpa_code')
  String? get lpaCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'smdp_address')
  String? get smdpAddress => throw _privateConstructorUsedError;

  /// Serializes this Sim to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sim
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SimCopyWith<Sim> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimCopyWith<$Res> {
  factory $SimCopyWith(Sim value, $Res Function(Sim) then) =
      _$SimCopyWithImpl<$Res, Sim>;
  @useResult
  $Res call({
    String iccid,
    String? status,
    String? type,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'country_name') String? countryName,
    @JsonKey(name: 'data_total_bytes') int? totalBytes,
    @JsonKey(name: 'data_used_bytes') int? usedBytes,
    @JsonKey(name: 'data_remaining_bytes') int? remainingBytes,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'activated_at') DateTime? activatedAt,
    String? qrcode,
    @JsonKey(name: 'ac_code') String? acCode,
    @JsonKey(name: 'lpa_code') String? lpaCode,
    @JsonKey(name: 'smdp_address') String? smdpAddress,
  });
}

/// @nodoc
class _$SimCopyWithImpl<$Res, $Val extends Sim> implements $SimCopyWith<$Res> {
  _$SimCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sim
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iccid = null,
    Object? status = freezed,
    Object? type = freezed,
    Object? packageName = freezed,
    Object? countryCode = freezed,
    Object? countryName = freezed,
    Object? totalBytes = freezed,
    Object? usedBytes = freezed,
    Object? remainingBytes = freezed,
    Object? expiresAt = freezed,
    Object? activatedAt = freezed,
    Object? qrcode = freezed,
    Object? acCode = freezed,
    Object? lpaCode = freezed,
    Object? smdpAddress = freezed,
  }) {
    return _then(
      _value.copyWith(
            iccid: null == iccid
                ? _value.iccid
                : iccid // ignore: cast_nullable_to_non_nullable
                      as String,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageName: freezed == packageName
                ? _value.packageName
                : packageName // ignore: cast_nullable_to_non_nullable
                      as String?,
            countryCode: freezed == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            countryName: freezed == countryName
                ? _value.countryName
                : countryName // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalBytes: freezed == totalBytes
                ? _value.totalBytes
                : totalBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            usedBytes: freezed == usedBytes
                ? _value.usedBytes
                : usedBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            remainingBytes: freezed == remainingBytes
                ? _value.remainingBytes
                : remainingBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            activatedAt: freezed == activatedAt
                ? _value.activatedAt
                : activatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            qrcode: freezed == qrcode
                ? _value.qrcode
                : qrcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            acCode: freezed == acCode
                ? _value.acCode
                : acCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            lpaCode: freezed == lpaCode
                ? _value.lpaCode
                : lpaCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            smdpAddress: freezed == smdpAddress
                ? _value.smdpAddress
                : smdpAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SimImplCopyWith<$Res> implements $SimCopyWith<$Res> {
  factory _$$SimImplCopyWith(_$SimImpl value, $Res Function(_$SimImpl) then) =
      __$$SimImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String iccid,
    String? status,
    String? type,
    @JsonKey(name: 'package_name') String? packageName,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'country_name') String? countryName,
    @JsonKey(name: 'data_total_bytes') int? totalBytes,
    @JsonKey(name: 'data_used_bytes') int? usedBytes,
    @JsonKey(name: 'data_remaining_bytes') int? remainingBytes,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'activated_at') DateTime? activatedAt,
    String? qrcode,
    @JsonKey(name: 'ac_code') String? acCode,
    @JsonKey(name: 'lpa_code') String? lpaCode,
    @JsonKey(name: 'smdp_address') String? smdpAddress,
  });
}

/// @nodoc
class __$$SimImplCopyWithImpl<$Res> extends _$SimCopyWithImpl<$Res, _$SimImpl>
    implements _$$SimImplCopyWith<$Res> {
  __$$SimImplCopyWithImpl(_$SimImpl _value, $Res Function(_$SimImpl) _then)
    : super(_value, _then);

  /// Create a copy of Sim
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iccid = null,
    Object? status = freezed,
    Object? type = freezed,
    Object? packageName = freezed,
    Object? countryCode = freezed,
    Object? countryName = freezed,
    Object? totalBytes = freezed,
    Object? usedBytes = freezed,
    Object? remainingBytes = freezed,
    Object? expiresAt = freezed,
    Object? activatedAt = freezed,
    Object? qrcode = freezed,
    Object? acCode = freezed,
    Object? lpaCode = freezed,
    Object? smdpAddress = freezed,
  }) {
    return _then(
      _$SimImpl(
        iccid: null == iccid
            ? _value.iccid
            : iccid // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageName: freezed == packageName
            ? _value.packageName
            : packageName // ignore: cast_nullable_to_non_nullable
                  as String?,
        countryCode: freezed == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        countryName: freezed == countryName
            ? _value.countryName
            : countryName // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalBytes: freezed == totalBytes
            ? _value.totalBytes
            : totalBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        usedBytes: freezed == usedBytes
            ? _value.usedBytes
            : usedBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        remainingBytes: freezed == remainingBytes
            ? _value.remainingBytes
            : remainingBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        activatedAt: freezed == activatedAt
            ? _value.activatedAt
            : activatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        qrcode: freezed == qrcode
            ? _value.qrcode
            : qrcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        acCode: freezed == acCode
            ? _value.acCode
            : acCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        lpaCode: freezed == lpaCode
            ? _value.lpaCode
            : lpaCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        smdpAddress: freezed == smdpAddress
            ? _value.smdpAddress
            : smdpAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SimImpl extends _Sim {
  const _$SimImpl({
    required this.iccid,
    this.status,
    this.type,
    @JsonKey(name: 'package_name') this.packageName,
    @JsonKey(name: 'country_code') this.countryCode,
    @JsonKey(name: 'country_name') this.countryName,
    @JsonKey(name: 'data_total_bytes') this.totalBytes,
    @JsonKey(name: 'data_used_bytes') this.usedBytes,
    @JsonKey(name: 'data_remaining_bytes') this.remainingBytes,
    @JsonKey(name: 'expires_at') this.expiresAt,
    @JsonKey(name: 'activated_at') this.activatedAt,
    this.qrcode,
    @JsonKey(name: 'ac_code') this.acCode,
    @JsonKey(name: 'lpa_code') this.lpaCode,
    @JsonKey(name: 'smdp_address') this.smdpAddress,
  }) : super._();

  factory _$SimImpl.fromJson(Map<String, dynamic> json) =>
      _$$SimImplFromJson(json);

  @override
  final String iccid;
  @override
  final String? status;
  @override
  final String? type;
  @override
  @JsonKey(name: 'package_name')
  final String? packageName;
  @override
  @JsonKey(name: 'country_code')
  final String? countryCode;
  @override
  @JsonKey(name: 'country_name')
  final String? countryName;

  /// Total data in bytes.
  @override
  @JsonKey(name: 'data_total_bytes')
  final int? totalBytes;
  @override
  @JsonKey(name: 'data_used_bytes')
  final int? usedBytes;
  @override
  @JsonKey(name: 'data_remaining_bytes')
  final int? remainingBytes;

  /// ISO-8601 expiry timestamp.
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @override
  @JsonKey(name: 'activated_at')
  final DateTime? activatedAt;

  /// eSIM QR / LPA fields (only present for eSIMs).
  @override
  final String? qrcode;
  @override
  @JsonKey(name: 'ac_code')
  final String? acCode;
  @override
  @JsonKey(name: 'lpa_code')
  final String? lpaCode;
  @override
  @JsonKey(name: 'smdp_address')
  final String? smdpAddress;

  @override
  String toString() {
    return 'Sim(iccid: $iccid, status: $status, type: $type, packageName: $packageName, countryCode: $countryCode, countryName: $countryName, totalBytes: $totalBytes, usedBytes: $usedBytes, remainingBytes: $remainingBytes, expiresAt: $expiresAt, activatedAt: $activatedAt, qrcode: $qrcode, acCode: $acCode, lpaCode: $lpaCode, smdpAddress: $smdpAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimImpl &&
            (identical(other.iccid, iccid) || other.iccid == iccid) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.countryName, countryName) ||
                other.countryName == countryName) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.usedBytes, usedBytes) ||
                other.usedBytes == usedBytes) &&
            (identical(other.remainingBytes, remainingBytes) ||
                other.remainingBytes == remainingBytes) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.activatedAt, activatedAt) ||
                other.activatedAt == activatedAt) &&
            (identical(other.qrcode, qrcode) || other.qrcode == qrcode) &&
            (identical(other.acCode, acCode) || other.acCode == acCode) &&
            (identical(other.lpaCode, lpaCode) || other.lpaCode == lpaCode) &&
            (identical(other.smdpAddress, smdpAddress) ||
                other.smdpAddress == smdpAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    iccid,
    status,
    type,
    packageName,
    countryCode,
    countryName,
    totalBytes,
    usedBytes,
    remainingBytes,
    expiresAt,
    activatedAt,
    qrcode,
    acCode,
    lpaCode,
    smdpAddress,
  );

  /// Create a copy of Sim
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimImplCopyWith<_$SimImpl> get copyWith =>
      __$$SimImplCopyWithImpl<_$SimImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SimImplToJson(this);
  }
}

abstract class _Sim extends Sim {
  const factory _Sim({
    required final String iccid,
    final String? status,
    final String? type,
    @JsonKey(name: 'package_name') final String? packageName,
    @JsonKey(name: 'country_code') final String? countryCode,
    @JsonKey(name: 'country_name') final String? countryName,
    @JsonKey(name: 'data_total_bytes') final int? totalBytes,
    @JsonKey(name: 'data_used_bytes') final int? usedBytes,
    @JsonKey(name: 'data_remaining_bytes') final int? remainingBytes,
    @JsonKey(name: 'expires_at') final DateTime? expiresAt,
    @JsonKey(name: 'activated_at') final DateTime? activatedAt,
    final String? qrcode,
    @JsonKey(name: 'ac_code') final String? acCode,
    @JsonKey(name: 'lpa_code') final String? lpaCode,
    @JsonKey(name: 'smdp_address') final String? smdpAddress,
  }) = _$SimImpl;
  const _Sim._() : super._();

  factory _Sim.fromJson(Map<String, dynamic> json) = _$SimImpl.fromJson;

  @override
  String get iccid;
  @override
  String? get status;
  @override
  String? get type;
  @override
  @JsonKey(name: 'package_name')
  String? get packageName;
  @override
  @JsonKey(name: 'country_code')
  String? get countryCode;
  @override
  @JsonKey(name: 'country_name')
  String? get countryName;

  /// Total data in bytes.
  @override
  @JsonKey(name: 'data_total_bytes')
  int? get totalBytes;
  @override
  @JsonKey(name: 'data_used_bytes')
  int? get usedBytes;
  @override
  @JsonKey(name: 'data_remaining_bytes')
  int? get remainingBytes;

  /// ISO-8601 expiry timestamp.
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  @JsonKey(name: 'activated_at')
  DateTime? get activatedAt;

  /// eSIM QR / LPA fields (only present for eSIMs).
  @override
  String? get qrcode;
  @override
  @JsonKey(name: 'ac_code')
  String? get acCode;
  @override
  @JsonKey(name: 'lpa_code')
  String? get lpaCode;
  @override
  @JsonKey(name: 'smdp_address')
  String? get smdpAddress;

  /// Create a copy of Sim
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimImplCopyWith<_$SimImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
