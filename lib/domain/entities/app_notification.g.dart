// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$AppNotificationImpl(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String? ?? 'service',
  titleEn: json['title_en'] as String?,
  titleZh: json['title_zh'] as String?,
  titleEs: json['title_es'] as String?,
  bodyEn: json['body_en'] as String?,
  bodyZh: json['body_zh'] as String?,
  bodyEs: json['body_es'] as String?,
  actionLabel: json['action_label'] as String?,
  actionTarget: json['action_target'] as String?,
  countryCode: json['country_code'] as String?,
  active: json['active'] as bool? ?? true,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$AppNotificationImplToJson(
  _$AppNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title_en': instance.titleEn,
  'title_zh': instance.titleZh,
  'title_es': instance.titleEs,
  'body_en': instance.bodyEn,
  'body_zh': instance.bodyZh,
  'body_es': instance.bodyEs,
  'action_label': instance.actionLabel,
  'action_target': instance.actionTarget,
  'country_code': instance.countryCode,
  'active': instance.active,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
