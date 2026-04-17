import 'package:flutter/painting.dart';

/// Centralized gradients. DO NOT construct ad-hoc `LinearGradient` in widgets.
abstract class AppGradients {
  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6600), Color(0xFFFF8A3D)],
  );

  static const LinearGradient heroDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6600), Color(0xFFCC0000)],
  );

  static const LinearGradient darkCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF334155)],
  );

  static const LinearGradient heroLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.4, 1.0],
    colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5), Color(0xFFFEF3C7)],
  );

  static const LinearGradient header = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFF6600), Color(0xFFFF8533)],
  );

  static const LinearGradient progressNormal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF6600), Color(0xFFFF8A3D)],
  );

  static const LinearGradient progressWarning = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
  );

  static const LinearGradient indicator = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF6600), Color(0xFFFF8533)],
  );

  static const LinearGradient darkPage = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0xFF1A0A00), Color(0xFF3D1800), Color(0xFF5C2600)],
  );

  static const RadialGradient glowOrange = RadialGradient(
    center: Alignment(0.7, 0.3),
    radius: 0.7,
    colors: [Color(0xFFFF6600), Color(0x00000000)],
  );

  static const RadialGradient glowYellow = RadialGradient(
    center: Alignment.center,
    radius: 0.7,
    colors: [Color(0xFFFFCC33), Color(0x00000000)],
  );
}
