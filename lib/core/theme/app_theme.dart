import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
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
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: GoogleFonts.inter(
              fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          headlineLarge: GoogleFonts.inter(
              fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          headlineMedium: GoogleFonts.inter(
              fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          titleLarge: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          titleMedium: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleSmall: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          bodyLarge: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
          bodyMedium: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
          bodySmall: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
          labelLarge: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          labelMedium: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          labelSmall: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      );
}
