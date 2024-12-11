import 'package:flutter/rendering.dart';

class SliderTrackPainter extends CustomPainter {
  final double offsetRadian;
  final double radius;
  final double strokeWidth;
  final double startRadian;
  final double lengthRadian;
  final Color color;

  const SliderTrackPainter({
    required this.offsetRadian,
    required this.radius,
    required this.strokeWidth,
    required this.startRadian,
    required this.lengthRadian,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

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
