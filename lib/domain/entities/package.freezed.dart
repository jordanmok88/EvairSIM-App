// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
mixin _$Package {
  @JsonKey(name: 'package_code')
  String get packageCode => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Total data volume in BYTES. Convert with [volumeDisplay].
  int get volume => throw _privateConstructorUsedError;

  /// Duration value (e.g. 7 for 7-day plan).
  int get duration => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_unit')
  String get durationUnit => throw _privateConstructorUsedError;

  /// ISO country code the plan belongs to (e.g. "US", "MX").
  String get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String get locationName => throw _privateConstructorUsedError;

  /// BASE = standalone plan, TOPUP = recharge, UNLIMITED etc.
  String get type => throw _privateConstructorUsedError;
  String get speed => throw _privateConstructorUsedError;
  List<String> get features => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Only present on /packages/hot
  @JsonKey(name: 'sales_count')
  int? get salesCount => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;

  /// Serializes this Package to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageCopyWith<Package> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) then) =
      _$PackageCopyWithImpl<$Res, Package>;
  @useResult
  $Res call({
    @JsonKey(name: 'package_code') String packageCode,
    String name,
    double price,
    String currency,
    int volume,
    int duration,
    @JsonKey(name: 'duration_unit') String durationUnit,
    String location,
    @JsonKey(name: 'location_name') String locationName,
    String type,
    String speed,
    List<String> features,
    String? description,
    @JsonKey(name: 'sales_count') int? salesCount,
    double? rating,
  });
}

/// @nodoc
class _$PackageCopyWithImpl<$Res, $Val extends Package>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageCode = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? volume = null,
    Object? duration = null,
    Object? durationUnit = null,
    Object? location = null,
    Object? locationName = null,
    Object? type = null,
    Object? speed = null,
    Object? features = null,
    Object? description = freezed,
    Object? salesCount = freezed,
    Object? rating = freezed,
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
            volume: null == volume
                ? _value.volume
                : volume // ignore: cast_nullable_to_non_nullable
                      as int,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            durationUnit: null == durationUnit
                ? _value.durationUnit
                : durationUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            locationName: null == locationName
                ? _value.locationName
                : locationName // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            speed: null == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                      as String,
            features: null == features
                ? _value.features
                : features // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            salesCount: freezed == salesCount
                ? _value.salesCount
                : salesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackageImplCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$$PackageImplCopyWith(
    _$PackageImpl value,
    $Res Function(_$PackageImpl) then,
  ) = __$$PackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'package_code') String packageCode,
    String name,
    double price,
    String currency,
    int volume,
    int duration,
    @JsonKey(name: 'duration_unit') String durationUnit,
    String location,
    @JsonKey(name: 'location_name') String locationName,
    String type,
    String speed,
    List<String> features,
    String? description,
    @JsonKey(name: 'sales_count') int? salesCount,
    double? rating,
  });
}

/// @nodoc
class __$$PackageImplCopyWithImpl<$Res>
    extends _$PackageCopyWithImpl<$Res, _$PackageImpl>
    implements _$$PackageImplCopyWith<$Res> {
  __$$PackageImplCopyWithImpl(
    _$PackageImpl _value,
    $Res Function(_$PackageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageCode = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? volume = null,
    Object? duration = null,
    Object? durationUnit = null,
    Object? location = null,
    Object? locationName = null,
    Object? type = null,
    Object? speed = null,
    Object? features = null,
    Object? description = freezed,
    Object? salesCount = freezed,
    Object? rating = freezed,
  }) {
    return _then(
      _$PackageImpl(
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
        volume: null == volume
            ? _value.volume
            : volume // ignore: cast_nullable_to_non_nullable
                  as int,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        durationUnit: null == durationUnit
            ? _value.durationUnit
            : durationUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        locationName: null == locationName
            ? _value.locationName
            : locationName // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        speed: null == speed
            ? _value.speed
            : speed // ignore: cast_nullable_to_non_nullable
                  as String,
        features: null == features
            ? _value._features
            : features // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        salesCount: freezed == salesCount
            ? _value.salesCount
            : salesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageImpl extends _Package {
  const _$PackageImpl({
    @JsonKey(name: 'package_code') required this.packageCode,
    required this.name,
    required this.price,
    this.currency = 'USD',
    this.volume = 0,
    this.duration = 0,
    @JsonKey(name: 'duration_unit') this.durationUnit = 'DAY',
    this.location = '',
    @JsonKey(name: 'location_name') this.locationName = '',
    this.type = 'BASE',
    this.speed = '4G',
    final List<String> features = const <String>[],
    this.description,
    @JsonKey(name: 'sales_count') this.salesCount,
    this.rating,
  }) : _features = features,
       super._();

  factory _$PackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageImplFromJson(json);

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

  /// Total data volume in BYTES. Convert with [volumeDisplay].
  @override
  @JsonKey()
  final int volume;

  /// Duration value (e.g. 7 for 7-day plan).
  @override
  @JsonKey()
  final int duration;
  @override
  @JsonKey(name: 'duration_unit')
  final String durationUnit;

  /// ISO country code the plan belongs to (e.g. "US", "MX").
  @override
  @JsonKey()
  final String location;
  @override
  @JsonKey(name: 'location_name')
  final String locationName;

  /// BASE = standalone plan, TOPUP = recharge, UNLIMITED etc.
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String speed;
  final List<String> _features;
  @override
  @JsonKey()
  List<String> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  final String? description;

  /// Only present on /packages/hot
  @override
  @JsonKey(name: 'sales_count')
  final int? salesCount;
  @override
  final double? rating;

  @override
  String toString() {
    return 'Package(packageCode: $packageCode, name: $name, price: $price, currency: $currency, volume: $volume, duration: $duration, durationUnit: $durationUnit, location: $location, locationName: $locationName, type: $type, speed: $speed, features: $features, description: $description, salesCount: $salesCount, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageImpl &&
            (identical(other.packageCode, packageCode) ||
                other.packageCode == packageCode) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.durationUnit, durationUnit) ||
                other.durationUnit == durationUnit) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.salesCount, salesCount) ||
                other.salesCount == salesCount) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    packageCode,
    name,
    price,
    currency,
    volume,
    duration,
    durationUnit,
    location,
    locationName,
    type,
    speed,
    const DeepCollectionEquality().hash(_features),
    description,
    salesCount,
    rating,
  );

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      __$$PackageImplCopyWithImpl<_$PackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageImplToJson(this);
  }
}

abstract class _Package extends Package {
  const factory _Package({
    @JsonKey(name: 'package_code') required final String packageCode,
    required final String name,
    required final double price,
    final String currency,
    final int volume,
    final int duration,
    @JsonKey(name: 'duration_unit') final String durationUnit,
    final String location,
    @JsonKey(name: 'location_name') final String locationName,
    final String type,
    final String speed,
    final List<String> features,
    final String? description,
    @JsonKey(name: 'sales_count') final int? salesCount,
    final double? rating,
  }) = _$PackageImpl;
  const _Package._() : super._();

  factory _Package.fromJson(Map<String, dynamic> json) = _$PackageImpl.fromJson;

  @override
  @JsonKey(name: 'package_code')
  String get packageCode;
  @override
  String get name;
  @override
  double get price;
  @override
  String get currency;

  /// Total data volume in BYTES. Convert with [volumeDisplay].
  @override
  int get volume;

  /// Duration value (e.g. 7 for 7-day plan).
  @override
  int get duration;
  @override
  @JsonKey(name: 'duration_unit')
  String get durationUnit;

  /// ISO country code the plan belongs to (e.g. "US", "MX").
  @override
  String get location;
  @override
  @JsonKey(name: 'location_name')
  String get locationName;

  /// BASE = standalone plan, TOPUP = recharge, UNLIMITED etc.
  @override
  String get type;
  @override
  String get speed;
  @override
  List<String> get features;
  @override
  String? get description;

  /// Only present on /packages/hot
  @override
  @JsonKey(name: 'sales_count')
  int? get salesCount;
  @override
  double? get rating;

  /// Create a copy of Package
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
