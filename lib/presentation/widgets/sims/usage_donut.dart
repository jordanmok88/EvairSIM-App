import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Custom-painted donut showing the % of data used. Avoids bringing in
/// fl_chart/syncfusion just for this.
class UsageDonut extends StatelessWidget {
  const UsageDonut({
    super.key,
    required this.percent,
    required this.centerTop,
    required this.centerBottom,
    this.size = 140,
    this.strokeWidth = 12,
    this.trackColor = AppColors.fillLight,
    this.progressColor = AppColors.brandOrange,
  });

  final double percent;
  final String centerTop;
  final String centerBottom;
  final double size;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    final p = percent.clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutPainter(
          percent: p,
          strokeWidth: strokeWidth,
          trackColor: trackColor,
          progressColor: progressColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                centerTop,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                centerBottom,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({
    required this.percent,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  final double percent;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final centerRect = rect.deflate(strokeWidth / 2);
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(
      centerRect.center,
      centerRect.shortestSide / 2,
      trackPaint,
    );

    if (percent <= 0) return;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          progressColor,
          AppColors.brandOrangeLight,
        ],
      ).createShader(centerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      centerRect,
      -math.pi / 2,
      2 * math.pi * percent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.percent != percent ||
      old.progressColor != progressColor ||
      old.trackColor != trackColor ||
      old.strokeWidth != strokeWidth;
}
