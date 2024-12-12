import 'package:circular_slider/circular_slider.dart';
import 'package:flutter/rendering.dart';

class SliderTrackPainter extends CustomPainter {
  final double offsetRadian;
  final double radius;
  final double startRadian;
  final double lengthRadian;
  final double strokeWidth;
  final StrokeCap? strokeCap;
  final Color? color;
  final List<Color>? gradientColors;
  final List<double>? gradientStops;
  final GradientMode gradientMode;

  const SliderTrackPainter({
    required this.offsetRadian,
    required this.radius,
    required this.startRadian,
    required this.lengthRadian,
    required this.strokeWidth,
    this.strokeCap,
    this.color,
    this.gradientColors,
    this.gradientStops,
    this.gradientMode = GradientMode.arc,
  }) : assert(color != null || gradientColors != null);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap ?? StrokeCap.round
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    double capRadian = 0.0;

    if (paint.strokeCap != StrokeCap.butt) {
      capRadian = ((strokeWidth / 2) / radius) - 0.005;
    }

    if (gradientColors == null) {
      paint.color = color!;
    } else {
      print('capRadian: $capRadian');

      double gradientEndAngle;

      if (gradientMode == GradientMode.circle) {
        gradientEndAngle = startRadian + 2 * 3.141;
      } else {
        gradientEndAngle = startRadian + lengthRadian + capRadian;
      }

      final gradient = SweepGradient(
        startAngle: startRadian - capRadian,
        endAngle: gradientEndAngle,
        colors: gradientColors!,
        stops: gradientStops,
        transform: GradientRotation(-capRadian),
      );

      paint.shader = gradient.createShader(rect);
    }

    // Save the canvas state
    canvas.save();

    // Rotate the entire canvas by the offset angle
    canvas.translate(center.dx, center.dy);
    canvas.rotate(offsetRadian);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawArc(
      rect,
      startRadian,
      lengthRadian,
      false,
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(SliderTrackPainter oldDelegate) {
    return offsetRadian != oldDelegate.offsetRadian ||
        radius != oldDelegate.radius ||
        strokeWidth != oldDelegate.strokeWidth ||
        startRadian != oldDelegate.startRadian ||
        lengthRadian != oldDelegate.lengthRadian ||
        color != oldDelegate.color;
  }
}
