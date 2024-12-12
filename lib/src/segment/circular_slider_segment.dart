import 'dart:ui';

import 'package:flutter/foundation.dart';

enum GradientMode {
  /// The gradient follows a closed circle
  circle,

  /// The gradient follows the length of the arc
  arc,
}

@immutable
class CircularSliderSegment {
  final double start;
  final double length;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final Color? color;
  final List<Color>? gradientColors;
  final List<double>? gradientStops;
  final GradientMode gradientMode;

  const CircularSliderSegment({
    required this.start,
    required this.length,
    required this.strokeWidth,
    this.strokeCap = StrokeCap.round,
    this.color,
    this.gradientColors,
    this.gradientStops,
    this.gradientMode = GradientMode.arc,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularSliderSegment &&
        other.start == start &&
        other.length == length &&
        other.strokeWidth == strokeWidth &&
        other.strokeCap == strokeCap &&
        other.color == color &&
        listEquals(other.gradientColors, gradientColors) &&
        listEquals(other.gradientStops, gradientStops) &&
        other.gradientMode == gradientMode;
  }

  @override
  int get hashCode {
    return start.hashCode ^
        length.hashCode ^
        strokeWidth.hashCode ^
        strokeCap.hashCode ^
        color.hashCode ^
        gradientColors.hashCode ^
        gradientStops.hashCode ^
        gradientMode.hashCode;
  }
}
