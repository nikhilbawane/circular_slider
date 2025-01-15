import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../enums.dart';

@immutable
class CircularSliderSegment {
  /// normalized value between 0.0 to 1.0, <br>
  /// representing a value proportional between [CircularSlider.min] and [CircularSlider.max]
  /// 
  /// example:
  /// min = 0.0, max = 100.0, value = 50.0
  /// min = 10.0, max = 50.0, value = 30.0
  final double start;

  /// normalized value between 0.0 to 1.0 <br>
  /// the length will be proportional to the length of the Slider
  final double length;

  /// width of the segment
  final double width;

  /// stroke cap of the segment
  final StrokeCap strokeCap;

  /// The color of the segment
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
    required this.width,
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
        other.width == width &&
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
        width.hashCode ^
        strokeCap.hashCode ^
        color.hashCode ^
        gradientColors.hashCode ^
        gradientStops.hashCode ^
        gradientMode.hashCode;
  }
}
