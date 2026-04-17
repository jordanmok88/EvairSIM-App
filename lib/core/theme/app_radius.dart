import 'package:flutter/painting.dart';

abstract class AppRadius {
  static const double r2 = 2;
  static const double r4 = 4;
  static const double r6 = 6;
  static const double r8 = 8;
  static const double r10 = 10;
  static const double r12 = 12;
  static const double r14 = 14;
  static const double r16 = 16;
  static const double r20 = 20;
  static const double r24 = 24;
  static const double r32 = 32;
  static const double r40 = 40;
  static const double r56 = 56;
  static const double full = 9999;

  static const BorderRadius button = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius card = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius cardSmall = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius cardLarge = BorderRadius.all(Radius.circular(r20));
  static const BorderRadius input = BorderRadius.all(Radius.circular(r10));
  static const BorderRadius modal = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius bottomSheet =
      BorderRadius.vertical(top: Radius.circular(r16));
  static const BorderRadius hero = BorderRadius.all(Radius.circular(r40));
  static const BorderRadius glass = BorderRadius.all(Radius.circular(r24));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));
}
