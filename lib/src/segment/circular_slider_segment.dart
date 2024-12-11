import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
class CircularSliderSegment {
  final Color color;
  final double start;
  final double length;
  final double width;

  const CircularSliderSegment({
    required this.color,
    required this.start,
    required this.length,
    required this.width,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularSliderSegment &&
        other.color == color &&
        other.start == start &&
        other.length == length &&
        other.width == width;
  }

  @override
  int get hashCode {
    return color.hashCode ^ start.hashCode ^ length.hashCode ^ width.hashCode;
  }
}
