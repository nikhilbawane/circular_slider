import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../enums.dart';

@immutable
class CircularSliderSegment {
  /// value between [CircularSlider.min] to [CircularSlider.max]
  final double start;

  /// value between [CircularSlider.min] to [CircularSlider.max]
  final double length;

  final double strokeWidth;
  final StrokeCap strokeCap;
  final Color? color;

  /// The gradient colors of the segment
  /// [gradientColors] and [gradientStops] must be of the same length
  /// This takes precedence over [color]
  final List<Color>? gradientColors;

  /// The gradient stops of the segment
  final List<double>? gradientStops;

  /// Controls how the gradient follows the segment
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
  }) : assert(color != null || gradientColors != null);

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
