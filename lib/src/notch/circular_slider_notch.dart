import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class CircularSliderNotch {
  final double radius;

  final Color color;

  final bool filled;

  final double strokeWidth;

  const CircularSliderNotch({
    required this.radius,
    required this.color,
    this.filled = true,
    this.strokeWidth = 1.0,
  });

  CircularSliderNotch copyWith({
    double? radius,
    Color? color,
    bool? filled,
    double? strokeWidth,
  }) {
    return CircularSliderNotch(
      radius: radius ?? this.radius,
      color: color ?? this.color,
      filled: filled ?? this.filled,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularSliderNotch &&
        other.radius == radius &&
        other.color == color &&
        other.filled == filled &&
        other.strokeWidth == strokeWidth;
  }

  @override
  int get hashCode {
    return radius.hashCode ^
        color.hashCode ^
        filled.hashCode ^
        strokeWidth.hashCode;
  }
}
