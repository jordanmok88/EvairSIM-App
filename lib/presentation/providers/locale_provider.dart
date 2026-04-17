import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/i18n/app_locale.dart';
import '../../core/network/secure_storage_provider.dart';

const _kLocaleKey = 'app_locale_code';

class LocaleController extends StateNotifier<AppLocale> {
  LocaleController(this._storage) : super(AppLocale.en) {
    _bootstrap();
  }
  final FlutterSecureStorage _storage;

  Future<void> _bootstrap() async {
    final code = await _storage.read(key: _kLocaleKey);
    if (code != null) state = AppLocale.fromCode(code);
  }

  Future<void> set(AppLocale locale) async {
    state = locale;
    await _storage.write(key: _kLocaleKey, value: locale.locale.languageCode);
  }
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, AppLocale>((ref) {
  return LocaleController(ref.watch(secureStorageProvider));
});
