import 'package:flutter/painting.dart';

abstract class AppShadows {
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 6)),
  ];
  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x4D000000), blurRadius: 16, offset: Offset(0, 8)),
  ];
  static const List<BoxShadow> xxl = [
    BoxShadow(color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 12)),
  ];

  static const List<BoxShadow> brandButton = [
    BoxShadow(color: Color(0x33FF6600), blurRadius: 14, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> brandCard = [
    BoxShadow(color: Color(0x33FF6600), blurRadius: 30, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static const List<BoxShadow> subtle = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 3, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> phoneFrame = [
    BoxShadow(color: Color(0x40000000), blurRadius: 100, offset: Offset(0, 50)),
  ];
}
