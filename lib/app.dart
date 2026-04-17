import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/i18n/app_locale.dart';
import 'core/i18n/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/widgets/layout/phone_frame.dart';

class EvairSimApp extends ConsumerWidget {
  const EvairSimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeControllerProvider);
    final strings = AppStrings.forLocale(locale);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: locale.locale,
      supportedLocales: AppLocale.values.map((l) => l.locale).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => LocalizedApp(
        strings: strings,
        child: PhoneFrame(child: child ?? const SizedBox()),
      ),
    );
  }
}
