import 'package:flutter/widgets.dart';

abstract class AppSpacing {
  // Page
  static const double pageHorizontal = 16;
  static const double pageHorizontalMd = 32;

  // Card
  static const double cardPadding = 16;
  static const double cardPaddingLarge = 20;
  static const double cardGap = 12;
  static const double cardGapLarge = 16;

  // Element (4px grid)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  // Button padding
  static const EdgeInsets buttonLargeH =
      EdgeInsets.symmetric(horizontal: 32, vertical: 14);
  static const EdgeInsets buttonPrimaryH =
      EdgeInsets.symmetric(horizontal: 0, vertical: 12);
  static const EdgeInsets buttonSecondaryH =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const EdgeInsets buttonSmallH =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const EdgeInsets buttonPillH =
      EdgeInsets.symmetric(horizontal: 14, vertical: 6);
}
