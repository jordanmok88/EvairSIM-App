import 'package:flutter/painting.dart';

/// EvairSIM brand colors — defined by China IT team's design system.
/// DO NOT use `Colors.white` / `Colors.black` anywhere — always reference this class.
abstract class AppColors {
  // ── Brand ──
  static const Color brandOrange = Color(0xFFFF6600);
  static const Color brandOrangeLight = Color(0xFFFF8A3D);
  static const Color brandRed = Color(0xFFCC0000);
  static const Color brandYellow = Color(0xFFFFCC33);
  static const Color slate850 = Color(0xFF1E293B);

  // ── Neutral / surface ──
  static const Color background = Color(0xFFF2F4F7);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textWeak = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF8E8E93);
  static const Color borderDefault = Color(0xFFE2E8F0);
  static const Color fillLight = Color(0xFFF1F5F9);
  static const Color inputBackground = Color(0xFFF8FAFC);

  // ── Semantic ──
  static const Color success = Color(0xFF22C55E);
  static const Color successDeep = Color(0xFF15803D);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successBorder = Color(0xFFBBF7D0);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDeep = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningBorder = Color(0xFFFED7AA);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color errorBorder = Color(0xFFFECACA);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFDBEAFE);

  static const Color purpleAccent = Color(0xFF8B5CF6);
  static const Color purpleBg = Color(0xFFF3E8FF);

  // ── Dark page (rare) ──
  static const Color darkPage = Color(0xFF1C1C1E);

  // ── Plain white/black substitutes (use only when absolutely needed) ──
  /// Pure white. Prefer `cardBackground` for surfaces.
  static const Color white = Color(0xFFFFFFFF);
  /// Pure black. Rarely used.
  static const Color black = Color(0xFF000000);
}
