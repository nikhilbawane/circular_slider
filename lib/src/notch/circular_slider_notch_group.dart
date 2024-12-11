import 'package:flutter/foundation.dart';

import 'circular_slider_notch.dart';

@immutable
class CircularSliderNotchGroup {
  final List<CircularSliderNotch> notches;

  final double spacing;

  /// The index of the step according to [CircularSlider.steps].
  ///
  /// Cannot be used with [value]
  final double? stepIndex;

  /// The value where the notch should be positioned.
  ///
  /// Must be between 0.0 and 1.0
  ///
  /// Cannot be used with [stepIndex]
  final double? value;

  const CircularSliderNotchGroup({
    required this.notches,
    this.spacing = 8.0,
    this.stepIndex,
    this.value,
  })  : assert(stepIndex != null || value != null),
        assert(stepIndex == null || value == null),
        assert(value == null || (value >= 0.0 && value <= 1.0));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularSliderNotchGroup &&
        listEquals(other.notches, notches) &&
        other.stepIndex == stepIndex &&
        other.value == value;
  }

  @override
  int get hashCode => notches.hashCode ^ stepIndex.hashCode ^ value.hashCode;
}
