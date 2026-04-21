import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const String _fontFamily = 'Inter';

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: _fontFamily,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.brandOrange,
          onPrimary: AppColors.white,
          secondary: AppColors.brandOrangeLight,
          onSecondary: AppColors.white,
          surface: AppColors.cardBackground,
          onSurface: AppColors.textPrimary,
          surfaceContainerHighest: AppColors.fillLight,
          onSurfaceVariant: AppColors.textSecondary,
          error: AppColors.error,
          onError: AppColors.white,
          outline: AppColors.borderDefault,
        ),
        scaffoldBackgroundColor: AppColors.background,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: _fontFamily,
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary),
          headlineLarge: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
          headlineMedium: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
          titleLarge: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
          titleMedium: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
          titleSmall: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
          bodyLarge: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary),
          bodyMedium: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary),
          bodySmall: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary),
          labelLarge: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
          labelMedium: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary),
          labelSmall: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary),
        ),
      );
}
