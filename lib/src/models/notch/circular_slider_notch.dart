import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class CircularSliderNotch {
  final double radius;

  final Color color;

  final bool filled;

  final double width;

  const CircularSliderNotch({
    required this.radius,
    required this.color,
    this.filled = true,
    this.width = 1.0,
  });

  CircularSliderNotch copyWith({
    double? radius,
    Color? color,
    bool? filled,
    double? width,
  }) {
    return CircularSliderNotch(
      radius: radius ?? this.radius,
      color: color ?? this.color,
      filled: filled ?? this.filled,
      width: width ?? this.width,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularSliderNotch &&
        other.radius == radius &&
        other.color == color &&
        other.filled == filled &&
        other.width == width;
  }

  @override
  int get hashCode {
    return radius.hashCode ^
        color.hashCode ^
        filled.hashCode ^
        width.hashCode;
  }
}
