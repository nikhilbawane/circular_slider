import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../notch/circular_slider_notch.dart';

class SliderNotchPainter extends CustomPainter {
  final List<CircularSliderNotch> notches;
  final double radius;
  final double radian;
  final double offsetRadian;
  final double spacing;

  SliderNotchPainter({
    required this.notches,
    this.radius = 0.0,
    this.radian = 0.0,
    this.offsetRadian = 0.0,
    this.spacing = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    for (var i = 0; i < notches.length; i++) {
      final notch = notches[i];

      final paint = Paint()
        ..color = notch.color
        ..strokeWidth = notch.strokeWidth
        ..style = notch.filled ? PaintingStyle.fill : PaintingStyle.stroke;

      final notchRadius = radius - (spacing * i);

      // Calculate the exact notch position based on radian
      final x = center.dx + math.cos(radian) * notchRadius;
      final y = center.dy + math.sin(radian) * notchRadius;

      canvas.drawCircle(Offset(x, y), notch.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is SliderNotchPainter) {
      return oldDelegate.offsetRadian != offsetRadian ||
          oldDelegate.radius != radius ||
          oldDelegate.radian != radian ||
          oldDelegate.spacing != spacing ||
          !listEquals(oldDelegate.notches, notches);
    }
    return true;
  }
}
