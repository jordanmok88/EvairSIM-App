import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/i18n/app_locale.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

/// Customer-facing notification posted by the admin portal (通知管理) and
/// served through `GET /v1/h5/notifications`.
///
/// The admin supports three languages (en / zh / es) and the customer app
/// picks the right one via [titleFor] / [bodyFor].
@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required int id,

    /// `promo` or `service`. Drives the card accent colour/icon.
    @Default('service') String type,

    @JsonKey(name: 'title_en') String? titleEn,
    @JsonKey(name: 'title_zh') String? titleZh,
    @JsonKey(name: 'title_es') String? titleEs,

    @JsonKey(name: 'body_en') String? bodyEn,
    @JsonKey(name: 'body_zh') String? bodyZh,
    @JsonKey(name: 'body_es') String? bodyEs,

    @JsonKey(name: 'action_label') String? actionLabel,
    @JsonKey(name: 'action_target') String? actionTarget,

    @JsonKey(name: 'country_code') String? countryCode,

    @Default(true) bool active,

    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  const AppNotification._();

  String titleFor(AppLocale locale) {
    switch (locale) {
      case AppLocale.zh:
        return (titleZh ?? titleEn ?? '').trim();
      case AppLocale.es:
        return (titleEs ?? titleEn ?? '').trim();
      case AppLocale.en:
        return (titleEn ?? '').trim();
    }
  }

  String bodyFor(AppLocale locale) {
    switch (locale) {
      case AppLocale.zh:
        return (bodyZh ?? bodyEn ?? '').trim();
      case AppLocale.es:
        return (bodyEs ?? bodyEn ?? '').trim();
      case AppLocale.en:
        return (bodyEn ?? '').trim();
    }
  }

  bool get isPromo => type.toLowerCase() == 'promo';
}
