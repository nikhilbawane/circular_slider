import 'dart:math' as math;
import 'dart:ui';

import 'package:circular_slider/src/constants.dart';

class SliderUtils {
  /// Normalizes an angle to a value between 0 and [maxAngle].
  ///
  /// This function takes an angle in radians and normalizes it to a value
  /// between 0 and [maxAngle] (defaulting to [fullAngleInRadians] if not
  /// provided).
  ///
  /// The normalization is done by first adding [maxAngle] to the angle to
  /// ensure it is positive, then taking the remainder modulo [maxAngle] to
  /// bring it back within the range.
  ///
  /// This is useful when dealing with angles that may wrap around the circle,
  /// such as when incrementing or decrementing an angle value.
  static double normalizeAngle(double angle, {double? maxAngle}) {
    final max = maxAngle ?? fullAngleInRadians;

    return (angle % max + max) % max;
  }

  /// Converts polar coordinates to a Cartesian offset.
  ///
  /// The polar coordinates are given by [radians] and [radius] and are
  /// relative to the point [center].
  ///
  /// The returned offset is relative to [center].
  ///
  /// See also:
  ///
  /// * [Offset.fromDirection], which is used to convert the polar coordinates
  ///   to a Cartesian offset.
  static Offset toPolar(Offset center, double radians, double radius) =>
      center + Offset.fromDirection(radians, radius);

  /// Computes the angle in radians from the positive x-axis to the line
  /// connecting the points [position] and [center].
  ///
  /// The angle is in the range `-pi` to `pi`.
  static double calculateAngle(Offset position, Offset center,
      {double offsetAngle = 0}) {
    final double touchAngle = (math.atan2(
          position.dy - center.dy,
          position.dx - center.dx,
        ) -
        offsetAngle);
    return touchAngle;
  }

  /// Converts an angle in degrees to radians.
  ///
  /// This function takes an angle in degrees, and returns the equivalent angle
  /// in radians.
  ///
  /// The formula used is `(value * pi) / 180`.
  static double angleToRadian(double value) {
    return (value * math.pi) / 180;
  }

  /// Converts an angle in radians to degrees.
  ///
  /// This function takes an angle in radians and returns the
  /// equivalent angle in degrees.
  ///
  /// The formula used is `(value * 180) / pi`.
  static double radianToAngle(double value) {
    return (value * 180) / math.pi;
  }

  /// Converts a length along the circumference of a circle to an angle in
  /// radians.
  ///
  /// The angle is calculated by dividing the length by the radius of the
  /// circle.
  ///
  /// The result is in the range [0, 2 * pi].
  static double lengthToRadians(double length, double radius) {
    return length / radius;
  }

  /// Calculates the angle of the tangent line at a given point on the circle
  /// of radius [r] centered at [center].
  ///
  /// The angle is in radians and is measured counter-clockwise from the positive
  /// x axis. The result is in the range [-pi, pi].
  ///
  /// If the point is above the circle, the result is the angle of the tangent line
  /// pointing down. If the point is below the circle, the result is the angle of
  /// the tangent line pointing up.
  static double getTangentAngle(Offset center, Offset point, double r) {
    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;
    final angle = math.atan2(dy, dx);
    return angle + math.pi / 2;
  }

  /// Checks if the given [angle] is within the arc from [startAngle] to [endAngle].
  ///
  /// The angles are all given in radians and are expected to be in the range [0, 2π).
  /// They are normalized to this range before the check is performed.
  ///
  /// The check is performed by mapping the angles to the range [0, 2π) and then
  /// checking if the given angle is within the range [start, end].
  ///
  /// If [endAngle] is less than [startAngle], the check is performed in the range
  /// [start, 2π) and [0, end].
  static bool isAngleInArc(double angle, double startAngle, double endAngle) {
    // Normalize all angles to [0, 2π)
    double normalize(double a) {
      a = a % (2 * math.pi);
      return a < 0 ? a + 2 * math.pi : a;
    }

    double normalizedAngle = normalize(angle);
    double start = normalize(startAngle);
    double end = normalize(endAngle);

    // Full-circle arc
    if (start == end) {
      return true;
    }

    // Angle is exactly at the boundaries
    if (normalizedAngle == start || normalizedAngle == end) {
      return true;
    }

    // Handle arcs that wrap around 0
    if (end < start) {
      return normalizedAngle >= start || normalizedAngle <= end;
    }

    // Normal case: end >= start
    return normalizedAngle >= start && normalizedAngle <= end;
  }

  /// Calculates the angular distance between two angles in radians,
  /// taking into account the wrapping around a full circle.
  /// If the start angle is less than or equal to the end angle,
  /// the result is the simple difference between them.
  /// Otherwise, it computes the distance by wrapping around the
  /// full circle. The returned value is in radians.
  static double getRadianLength(double angle1, double angle2) {
    const fullCircle = 2 * math.pi;
    if (angle1 <= angle2) {
      return angle2 - angle1;
    } else {
      return fullCircle - angle1 + angle2;
    }
  }

  /// Rounds a normalized [value] to the nearest division.
  ///
  /// This function takes a [value] in the range [0.0, 1.0] and a number
  /// of [divisions], and returns the [value] rounded to the nearest division.
  ///
  /// The [value] is first multiplied by [divisions], then rounded to the
  /// nearest integer, and finally divided by [divisions] to normalize it
  /// back to the original range.
  ///
  /// - [value]: A double value between 0.0 and 1.0.
  /// - [divisions]: The number of divisions to round the [value] to.
  static double discretize(double value, int divisions) {
    assert(value >= 0.0 && value <= 1.0);
    return (value * divisions).round() / divisions;
  }

  /// Linear interpolation between [start] and [end] based on [t].
  ///
  /// [t] is clamped to the range [0.0, 1.0] before performing the interpolation.
  ///
  /// This function is monotonic and continuous, meaning it will always return
  /// a value between [start] and [end], and it will never jump discontinuously.
  ///
  /// For example, if [start] is 0.0 and [end] is 100.0, calling `lerp(0.0, 100.0, 0.5)`
  /// will return 50.0.
  static double lerp(double start, double end, double t) =>
      start + (end - start) * t.clamp(0.0, 1.0);

  /// Reverses a linear interpolation.
  ///
  /// This function takes an interpolated value [value] that is between [start]
  /// and [end], and returns a value between 0.0 and 1.0 that represents where
  /// [value] is between [start] and [end].
  ///
  /// If [start] is equal to [end], the function returns 0.0.
  ///
  /// For example, if [start] is 0.0 and [end] is 100.0, calling
  /// `unLerp(0.0, 100.0, 50.0)` will return 0.5.
  static double unLerp(double start, double end, double value) {
    if (start == end) return 0.0;
    return (value - start) / (end - start);
  }

  /// Snaps a [value] to the nearest division within a specified range.
  ///
  /// This function normalizes the [value] within the [min] and [max] range,
  /// discretizes it into the specified number of [divisions], and then
  /// interpolates back to the original range using linear interpolation.
  ///
  /// The [value] is clamped to ensure it falls within the range, and the result
  /// will always be within the [min] and [max] bounds.
  ///
  /// - [value]: The value to be snapped.
  /// - [min]: The minimum value of the range.
  /// - [max]: The maximum value of the range.
  /// - [divisions]: The number of discrete steps within the range.
  ///
  /// Returns the snapped value.
  static double snapToGrid(
      double value, double min, double max, int divisions) {
    final normalizedValue = (value - min) / (max - min);
    final discreteValue =
        discretize(normalizedValue.clamp(0.0, 1.0), divisions);
    return lerp(min, max, discreteValue);
  }
}
