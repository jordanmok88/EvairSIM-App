// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) {
  return _AppNotification.fromJson(json);
}

/// @nodoc
mixin _$AppNotification {
  int get id => throw _privateConstructorUsedError;

  /// `promo` or `service`. Drives the card accent colour/icon.
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'title_en')
  String? get titleEn => throw _privateConstructorUsedError;
  @JsonKey(name: 'title_zh')
  String? get titleZh => throw _privateConstructorUsedError;
  @JsonKey(name: 'title_es')
  String? get titleEs => throw _privateConstructorUsedError;
  @JsonKey(name: 'body_en')
  String? get bodyEn => throw _privateConstructorUsedError;
  @JsonKey(name: 'body_zh')
  String? get bodyZh => throw _privateConstructorUsedError;
  @JsonKey(name: 'body_es')
  String? get bodyEs => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_label')
  String? get actionLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_target')
  String? get actionTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_code')
  String? get countryCode => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppNotificationCopyWith<AppNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNotificationCopyWith<$Res> {
  factory $AppNotificationCopyWith(
    AppNotification value,
    $Res Function(AppNotification) then,
  ) = _$AppNotificationCopyWithImpl<$Res, AppNotification>;
  @useResult
  $Res call({
    int id,
    String type,
    @JsonKey(name: 'title_en') String? titleEn,
    @JsonKey(name: 'title_zh') String? titleZh,
    @JsonKey(name: 'title_es') String? titleEs,
    @JsonKey(name: 'body_en') String? bodyEn,
    @JsonKey(name: 'body_zh') String? bodyZh,
    @JsonKey(name: 'body_es') String? bodyEs,
    @JsonKey(name: 'action_label') String? actionLabel,
    @JsonKey(name: 'action_target') String? actionTarget,
    @JsonKey(name: 'country_code') String? countryCode,
    bool active,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$AppNotificationCopyWithImpl<$Res, $Val extends AppNotification>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? titleEn = freezed,
    Object? titleZh = freezed,
    Object? titleEs = freezed,
    Object? bodyEn = freezed,
    Object? bodyZh = freezed,
    Object? bodyEs = freezed,
    Object? actionLabel = freezed,
    Object? actionTarget = freezed,
    Object? countryCode = freezed,
    Object? active = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            titleEn: freezed == titleEn
                ? _value.titleEn
                : titleEn // ignore: cast_nullable_to_non_nullable
                      as String?,
            titleZh: freezed == titleZh
                ? _value.titleZh
                : titleZh // ignore: cast_nullable_to_non_nullable
                      as String?,
            titleEs: freezed == titleEs
                ? _value.titleEs
                : titleEs // ignore: cast_nullable_to_non_nullable
                      as String?,
            bodyEn: freezed == bodyEn
                ? _value.bodyEn
                : bodyEn // ignore: cast_nullable_to_non_nullable
                      as String?,
            bodyZh: freezed == bodyZh
                ? _value.bodyZh
                : bodyZh // ignore: cast_nullable_to_non_nullable
                      as String?,
            bodyEs: freezed == bodyEs
                ? _value.bodyEs
                : bodyEs // ignore: cast_nullable_to_non_nullable
                      as String?,
            actionLabel: freezed == actionLabel
                ? _value.actionLabel
                : actionLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
            actionTarget: freezed == actionTarget
                ? _value.actionTarget
                : actionTarget // ignore: cast_nullable_to_non_nullable
                      as String?,
            countryCode: freezed == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            active: null == active
                ? _value.active
                : active // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppNotificationImplCopyWith<$Res>
    implements $AppNotificationCopyWith<$Res> {
  factory _$$AppNotificationImplCopyWith(
    _$AppNotificationImpl value,
    $Res Function(_$AppNotificationImpl) then,
  ) = __$$AppNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String type,
    @JsonKey(name: 'title_en') String? titleEn,
    @JsonKey(name: 'title_zh') String? titleZh,
    @JsonKey(name: 'title_es') String? titleEs,
    @JsonKey(name: 'body_en') String? bodyEn,
    @JsonKey(name: 'body_zh') String? bodyZh,
    @JsonKey(name: 'body_es') String? bodyEs,
    @JsonKey(name: 'action_label') String? actionLabel,
    @JsonKey(name: 'action_target') String? actionTarget,
    @JsonKey(name: 'country_code') String? countryCode,
    bool active,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$AppNotificationImplCopyWithImpl<$Res>
    extends _$AppNotificationCopyWithImpl<$Res, _$AppNotificationImpl>
    implements _$$AppNotificationImplCopyWith<$Res> {
  __$$AppNotificationImplCopyWithImpl(
    _$AppNotificationImpl _value,
    $Res Function(_$AppNotificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? titleEn = freezed,
    Object? titleZh = freezed,
    Object? titleEs = freezed,
    Object? bodyEn = freezed,
    Object? bodyZh = freezed,
    Object? bodyEs = freezed,
    Object? actionLabel = freezed,
    Object? actionTarget = freezed,
    Object? countryCode = freezed,
    Object? active = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$AppNotificationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        titleEn: freezed == titleEn
            ? _value.titleEn
            : titleEn // ignore: cast_nullable_to_non_nullable
                  as String?,
        titleZh: freezed == titleZh
            ? _value.titleZh
            : titleZh // ignore: cast_nullable_to_non_nullable
                  as String?,
        titleEs: freezed == titleEs
            ? _value.titleEs
            : titleEs // ignore: cast_nullable_to_non_nullable
                  as String?,
        bodyEn: freezed == bodyEn
            ? _value.bodyEn
            : bodyEn // ignore: cast_nullable_to_non_nullable
                  as String?,
        bodyZh: freezed == bodyZh
            ? _value.bodyZh
            : bodyZh // ignore: cast_nullable_to_non_nullable
                  as String?,
        bodyEs: freezed == bodyEs
            ? _value.bodyEs
            : bodyEs // ignore: cast_nullable_to_non_nullable
                  as String?,
        actionLabel: freezed == actionLabel
            ? _value.actionLabel
            : actionLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
        actionTarget: freezed == actionTarget
            ? _value.actionTarget
            : actionTarget // ignore: cast_nullable_to_non_nullable
                  as String?,
        countryCode: freezed == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        active: null == active
            ? _value.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppNotificationImpl extends _AppNotification {
  const _$AppNotificationImpl({
    required this.id,
    this.type = 'service',
    @JsonKey(name: 'title_en') this.titleEn,
    @JsonKey(name: 'title_zh') this.titleZh,
    @JsonKey(name: 'title_es') this.titleEs,
    @JsonKey(name: 'body_en') this.bodyEn,
    @JsonKey(name: 'body_zh') this.bodyZh,
    @JsonKey(name: 'body_es') this.bodyEs,
    @JsonKey(name: 'action_label') this.actionLabel,
    @JsonKey(name: 'action_target') this.actionTarget,
    @JsonKey(name: 'country_code') this.countryCode,
    this.active = true,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$AppNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppNotificationImplFromJson(json);

  @override
  final int id;

  /// `promo` or `service`. Drives the card accent colour/icon.
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey(name: 'title_en')
  final String? titleEn;
  @override
  @JsonKey(name: 'title_zh')
  final String? titleZh;
  @override
  @JsonKey(name: 'title_es')
  final String? titleEs;
  @override
  @JsonKey(name: 'body_en')
  final String? bodyEn;
  @override
  @JsonKey(name: 'body_zh')
  final String? bodyZh;
  @override
  @JsonKey(name: 'body_es')
  final String? bodyEs;
  @override
  @JsonKey(name: 'action_label')
  final String? actionLabel;
  @override
  @JsonKey(name: 'action_target')
  final String? actionTarget;
  @override
  @JsonKey(name: 'country_code')
  final String? countryCode;
  @override
  @JsonKey()
  final bool active;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AppNotification(id: $id, type: $type, titleEn: $titleEn, titleZh: $titleZh, titleEs: $titleEs, bodyEn: $bodyEn, bodyZh: $bodyZh, bodyEs: $bodyEs, actionLabel: $actionLabel, actionTarget: $actionTarget, countryCode: $countryCode, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.titleEn, titleEn) || other.titleEn == titleEn) &&
            (identical(other.titleZh, titleZh) || other.titleZh == titleZh) &&
            (identical(other.titleEs, titleEs) || other.titleEs == titleEs) &&
            (identical(other.bodyEn, bodyEn) || other.bodyEn == bodyEn) &&
            (identical(other.bodyZh, bodyZh) || other.bodyZh == bodyZh) &&
            (identical(other.bodyEs, bodyEs) || other.bodyEs == bodyEs) &&
            (identical(other.actionLabel, actionLabel) ||
                other.actionLabel == actionLabel) &&
            (identical(other.actionTarget, actionTarget) ||
                other.actionTarget == actionTarget) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    titleEn,
    titleZh,
    titleEs,
    bodyEn,
    bodyZh,
    bodyEs,
    actionLabel,
    actionTarget,
    countryCode,
    active,
    createdAt,
    updatedAt,
  );

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      __$$AppNotificationImplCopyWithImpl<_$AppNotificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppNotificationImplToJson(this);
  }
}

abstract class _AppNotification extends AppNotification {
  const factory _AppNotification({
    required final int id,
    final String type,
    @JsonKey(name: 'title_en') final String? titleEn,
    @JsonKey(name: 'title_zh') final String? titleZh,
    @JsonKey(name: 'title_es') final String? titleEs,
    @JsonKey(name: 'body_en') final String? bodyEn,
    @JsonKey(name: 'body_zh') final String? bodyZh,
    @JsonKey(name: 'body_es') final String? bodyEs,
    @JsonKey(name: 'action_label') final String? actionLabel,
    @JsonKey(name: 'action_target') final String? actionTarget,
    @JsonKey(name: 'country_code') final String? countryCode,
    final bool active,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$AppNotificationImpl;
  const _AppNotification._() : super._();

  factory _AppNotification.fromJson(Map<String, dynamic> json) =
      _$AppNotificationImpl.fromJson;

  @override
  int get id;

  /// `promo` or `service`. Drives the card accent colour/icon.
  @override
  String get type;
  @override
  @JsonKey(name: 'title_en')
  String? get titleEn;
  @override
  @JsonKey(name: 'title_zh')
  String? get titleZh;
  @override
  @JsonKey(name: 'title_es')
  String? get titleEs;
  @override
  @JsonKey(name: 'body_en')
  String? get bodyEn;
  @override
  @JsonKey(name: 'body_zh')
  String? get bodyZh;
  @override
  @JsonKey(name: 'body_es')
  String? get bodyEs;
  @override
  @JsonKey(name: 'action_label')
  String? get actionLabel;
  @override
  @JsonKey(name: 'action_target')
  String? get actionTarget;
  @override
  @JsonKey(name: 'country_code')
  String? get countryCode;
  @override
  bool get active;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of AppNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppNotificationImplCopyWith<_$AppNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
