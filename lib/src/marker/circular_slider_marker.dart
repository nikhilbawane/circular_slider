import 'package:flutter/widgets.dart';

@immutable
class CircularSliderMarker {
  final Widget marker;

  final Size size;

  /// Locks the marker rotation to the center of the slider circle
  final bool lockRotation;

  /// The index of the step according to [CircularSlider.steps].
  ///
  /// Cannot be used with [value]
  final double? stepIndex;

  /// The value where the marker should be positioned.
  ///
  /// The value must be between 0.0 and 1.0
  ///
  /// Cannot be used with [stepIndex]
  final double? value;

  const CircularSliderMarker({
    required this.marker,
    required this.size,
    this.lockRotation = true,
    this.stepIndex,
    this.value,
  })  : assert(stepIndex != null || value != null),
        assert(stepIndex == null || value == null),
        assert(value == null || (value >= 0.0 && value <= 1.0));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircularSliderMarker &&
        other.marker == marker &&
        other.size == size &&
        other.stepIndex == stepIndex &&
        other.value == value &&
        other.lockRotation == lockRotation;
  }

  @override
  int get hashCode {
    return marker.hashCode ^
        size.hashCode ^
        stepIndex.hashCode ^
        value.hashCode ^
        lockRotation.hashCode;
  }
}
