import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../enums.dart';

@immutable
class CircularSliderTrack {
  /// The width of the track
  ///
  /// Note: Make sure that
  /// [strokeWidth] <= [CircularSlider.radius] / 2
  /// otherwise there may be unexpected results
  ///
  /// This also affects the starting radius of the notches:
  /// Notch Starting Radius = [radius] - [strokeWidth] + [notchRingOffset]
  /// So if you notches get hidden by your track, try adjusting [notchRingOffset]
  final double strokeWidth;

  /// The stroke cap of the track
  final StrokeCap strokeCap;

  /// The color of the track
  final Color? color;

  /// The gradient colors of the segment
  /// [gradientColors] and [gradientStops] must be of the same length
  /// This takes precedence over [color]
  final List<Color>? gradientColors;

  /// The gradient stops of the segment
  final List<double>? gradientStops;

  /// Controls how the gradient follows the segment
  final GradientMode gradientMode;

  const CircularSliderTrack({
    required this.strokeWidth,
    this.strokeCap = StrokeCap.round,
    this.color = const Color(0xFFEEEEEE),
    this.gradientColors,
    this.gradientStops,
    this.gradientMode = GradientMode.arc,
  }) : assert(color != null || gradientColors != null);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularSliderTrack &&
        other.strokeWidth == strokeWidth &&
        other.strokeCap == strokeCap &&
        other.color == color &&
        listEquals(other.gradientColors, gradientColors) &&
        listEquals(other.gradientStops, gradientStops) &&
        other.gradientMode == gradientMode;
  }

  @override
  int get hashCode {
    return strokeWidth.hashCode ^
        strokeCap.hashCode ^
        color.hashCode ^
        gradientColors.hashCode ^
        gradientStops.hashCode ^
        gradientMode.hashCode;
  }
}
