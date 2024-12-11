import 'dart:math' as math;

import 'package:circular_slider/src/utils.dart';
import 'package:flutter/rendering.dart';

class SliderArrowPainter extends CustomPainter {
  final double offsetRadian;
  final double radius;
  final double strokeWidth;
  final double startRadian;
  final double lengthRadian;
  final Color color;

  // Constants for arrow head
  static const double _arrowHeadAngle = 0.6;
  static const double _arrowHeadLength = 8.0;

  SliderArrowPainter({
    required this.offsetRadian,
    required this.radius,
    required this.strokeWidth,
    required this.startRadian,
    required this.lengthRadian,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || radius <= 0 || strokeWidth <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);

    // Create a rect that defines the arc's bounds
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Save the canvas state
    canvas.save();

    // Rotate the entire canvas by the offset angle
    canvas.translate(center.dx, center.dy);
    canvas.rotate(offsetRadian);
    canvas.translate(-center.dx, -center.dy);

    _drawTrack(canvas, center, rect);
    _drawArrowHead(canvas, center);

    canvas.restore();
  }

  void _drawTrack(Canvas canvas, Offset center, Rect rect) {
    final gradient = SweepGradient(
      startAngle: startRadian,
      endAngle: startRadian + lengthRadian,
      colors: [color.withOpacity(0.0), color],
    );

    final trackPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true; // Ensure smooth edges

    canvas.drawArc(rect, startRadian, lengthRadian, false, trackPaint);
  }

  void _drawArrowHead(Canvas canvas, Offset center) {
    final endAngle = startRadian + lengthRadian;

    // Calculate arrow head position
    final arrowHeadCenter = Offset(
      center.dx + math.cos(endAngle) * radius,
      center.dy + math.sin(endAngle) * radius,
    );

    final baseAngle =
        SliderUtils.getTangentAngle(center, arrowHeadCenter, radius) - math.pi;

    // Calculate arrow head points
    final arrowHead1 = SliderUtils.toPolar(
      arrowHeadCenter,
      baseAngle + _arrowHeadAngle,
      _arrowHeadLength,
    );

    final arrowHead2 = SliderUtils.toPolar(
      arrowHeadCenter,
      baseAngle - _arrowHeadAngle,
      _arrowHeadLength,
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    // Draw arrow head
    canvas.drawLine(arrowHeadCenter, arrowHead1, paint);
    canvas.drawLine(arrowHeadCenter, arrowHead2, paint);
  }

  @override
  bool shouldRepaint(covariant SliderArrowPainter oldDelegate) {
    return oldDelegate.offsetRadian != offsetRadian ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.startRadian != startRadian ||
        oldDelegate.lengthRadian != lengthRadian ||
        oldDelegate.color != color;
  }
}
