import 'package:flutter/widgets.dart';

/// Locales supported by EvairSIM.
enum AppLocale {
  en(Locale('en'), 'English', '🇺🇸'),
  zh(Locale('zh'), '中文', '🇨🇳'),
  es(Locale('es'), 'Español', '🇪🇸');

  const AppLocale(this.locale, this.label, this.flag);
  final Locale locale;
  final String label;
  final String flag;

  static AppLocale fromCode(String code) {
    return AppLocale.values.firstWhere(
      (l) => l.locale.languageCode == code,
      orElse: () => AppLocale.en,
    );
  }
}
