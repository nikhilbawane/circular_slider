import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'constants.dart';
import 'models/enums.dart';
import 'models/models.dart';
import 'painter/slider_arrow_painter.dart';
import 'painter/slider_notch_painter.dart';
import 'painter/slider_track_painter.dart';
import 'utils.dart';

typedef KnobBuilder = Widget Function(
  BuildContext context,
  double angle,
);

enum InteractionMode {
  track,
  knob,
  both,
  none;

  bool get hasTrack {
    return this == InteractionMode.track || this == InteractionMode.both;
  }

  bool get hasKnob {
    return this == InteractionMode.knob || this == InteractionMode.both;
  }
}

/// CircularSlider widget
///
/// References:
/// https://www.youtube.com/watch?v=IP0Nn9f2yJs
/// https://github.com/JideGuru/youtube_videos/blob/master/rainbow_circular_slider/lib/views/circular_slider.dart
class CircularSlider extends StatefulWidget {
  /// Value between min and max
  final double value;

  /// The minimum value of the slider
  final double min;

  /// The maximum value of the slider
  final double max;

  /// Builder for the control knob
  /// Provides the angle in radians
  final KnobBuilder knobBuilder;

  /// Called when the slider's value changes
  final void Function(double radian) onChanged;

  /// The number of discrete steps within the range
  final int steps;

  /// The radius of the slider
  final double radius;

  /// in radians less than or equal to (pi * 2)
  /// [startAngle] must be less than [endAngle]
  final double startAngle;

  /// in radians less than or equal to (pi * 2)
  /// [startAngle] must be less than [endAngle]
  final double endAngle;

  /// Adjust the rotation of the slider
  final double offsetRadian;

  /// Slider track parameters
  final CircularSliderTrack track;

  /// List of segments
  final List<CircularSliderSegment>? segments;

  /// List of markers
  final List<CircularSliderMarker>? markers;

  /// This requires steps to be greater than 0
  final List<CircularSliderNotchGroup>? notchGroups;

  /// Increase this to move the notches away from the center
  /// Decreasing brings them closer
  final double notchRingOffset;

  /// Size of the control knob
  final Size knobSize;

  /// Alignment of the knob
  /// 0 = Center of slider
  /// 1 = On the slider's track
  final double knobAlignment;

  /// Tangentially locks the knob's rotation
  final bool lockKnobRotation;

  /// Show the directional arrow at the end of the track
  final bool showArrow;

  /// Control the value of the slider using track or knob or both
  final InteractionMode interactionMode;

  const CircularSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    required this.knobBuilder,
    required this.onChanged,
    this.steps = 0,
    required this.radius,
    this.startAngle = 0.0,
    this.endAngle = math.pi * 2.0,
    this.offsetRadian = 0.0,
    this.track = const CircularSliderTrack(
      color: defaultTrackColor,
      width: defaultStrokeWidth,
      strokeCap: StrokeCap.round,
      gradientMode: GradientMode.arc,
    ),
    this.segments,
    this.markers,
    this.notchGroups,
    this.notchRingOffset = 0.0,
    this.knobSize = const Size.square(defaultKnobSize),
    this.knobAlignment = 1.0,
    this.lockKnobRotation = false,
    this.showArrow = true,
    this.interactionMode = InteractionMode.both,
  })  : assert(startAngle <= (math.pi * 2) &&
            endAngle <= (math.pi * 2) &&
            startAngle < endAngle),
        assert(knobAlignment >= -1.0 && knobAlignment <= 1.0),
        assert(min != max && min < max);

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  double _knobStartAngle = 0.0;
  double _knobPreviousAngle = 0.0;
  double _currentRadian = 0.0;
  bool _isDragging = false;

  // Check if touch is within the slider's hit area
  bool _isInHitArea(
      Offset position, Offset center, double radius, double strokeWidth) {
    final double distance = (position - center).distance;

    if (distance < radius - strokeWidth || distance > radius + strokeWidth) {
      return false;
    }

    final double angle = SliderUtils.calculateAngle(position, center);

    double capRadians = SliderUtils.lengthToRadians(strokeWidth / 2, radius);

    if (widget.track.strokeCap == StrokeCap.butt) {
      capRadians = 0;
    }

    final arcStart = widget.startAngle + widget.offsetRadian - capRadians;
    final arcEnd = widget.endAngle + widget.offsetRadian + capRadians;

    final result = SliderUtils.isAngleInArc(angle, arcStart, arcEnd);

    return result;
  }

  void _handlePanStart(DragStartDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset center = size.center(Offset.zero);
    final double radius = widget.radius;

    final Offset localPosition =
        renderBox.globalToLocal(details.globalPosition);

    if (_isInHitArea(localPosition, center, radius, widget.track.width)) {
      _isDragging = true;
      _knobStartAngle = SliderUtils.calculateAngle(localPosition, center);
      _knobPreviousAngle = _knobStartAngle;

      final normalizedValue =
          SliderUtils.normalize(widget.min, widget.max, widget.value);

      _currentRadian = SliderUtils.lerp(
        widget.startAngle,
        widget.endAngle,
        normalizedValue,
      );
    }
  }

  void _handleKnobPanStart(DragStartDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset center = size.center(Offset.zero);

    final Offset localPosition =
        renderBox.globalToLocal(details.globalPosition);

    _isDragging = true;
    _knobStartAngle = SliderUtils.calculateAngle(localPosition, center);
    _knobPreviousAngle = _knobStartAngle;

    final normalizedValue =
        SliderUtils.normalize(widget.min, widget.max, widget.value);

    _currentRadian = SliderUtils.lerp(
      widget.startAngle,
      widget.endAngle,
      normalizedValue,
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset center = size.center(Offset.zero);

    final Offset localPosition =
        renderBox.globalToLocal(details.globalPosition);
    final double currentAngle =
        SliderUtils.calculateAngle(localPosition, center);

    // Calculate the change in angle since the last update
    double deltaAngle = currentAngle - _knobPreviousAngle;

    // Handle angle wrap-around
    if (deltaAngle > math.pi) {
      deltaAngle -= 2 * math.pi;
    } else if (deltaAngle < -math.pi) {
      deltaAngle += 2 * math.pi;
    }

    // Update the current value based on the angle change
    _currentRadian =
        (_currentRadian + deltaAngle).clamp(widget.startAngle, widget.endAngle);

    // convert _currentRadian to a value between 0 and 1
    final double normalizedValue = (_currentRadian - widget.startAngle) /
        (widget.endAngle - widget.startAngle);

    double newValue = SliderUtils.lerp(
      widget.min,
      widget.max,
      normalizedValue,
    );

    if (widget.steps > 0) {
      newValue = SliderUtils.snapToGrid(
          newValue, widget.min, widget.max, widget.steps);
    }

    if (newValue != widget.value) {
      widget.onChanged(newValue);
    }

    _knobPreviousAngle = currentAngle;
  }

  void _handlePanEnd(DragEndDetails details) {
    _isDragging = false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final center = Offset((size.width / 2), size.height / 2);

        return _buildSliderStack(center);
      },
    );
  }

  Widget _buildSliderStack(Offset center) {
    final sliderStack = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        _buildTrack(),
        if (widget.showArrow) _buildArrow(),
        if (widget.notchGroups != null) ..._buildNotches(),
        if (widget.segments != null) ..._buildSegments(),
        if (widget.markers != null) ..._buildMarkers(center),
        _buildKnob(center),
      ],
    );

    if (widget.interactionMode.hasTrack) {
      return GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: (details) => _handlePanUpdate(details),
        onPanEnd: _handlePanEnd,
        child: sliderStack,
      );
    } else {
      return sliderStack;
    }
  }

  Widget _buildTrack() {
    return CustomPaint(
      painter: SliderTrackPainter(
        offsetRadian: widget.offsetRadian,
        radius: widget.radius,
        strokeWidth: widget.track.width,
        strokeCap: widget.track.strokeCap,
        startRadian: widget.startAngle,
        lengthRadian:
            SliderUtils.getRadianLength(widget.startAngle, widget.endAngle),
        color: widget.track.color,
        gradientColors: widget.track.gradientColors,
        gradientStops: widget.track.gradientStops,
        gradientMode: widget.track.gradientMode,
      ),
      child: Container(),
    );
  }

  Widget _buildArrow() {
    final arcLength =
        SliderUtils.getRadianLength(widget.startAngle, widget.endAngle);

    return CustomPaint(
      painter: SliderArrowPainter(
        offsetRadian: widget.offsetRadian,
        radius: widget.radius,
        strokeWidth: 2.0,
        startRadian: widget.startAngle + 0.9 * arcLength,
        lengthRadian: 0.1 * arcLength,
        color: const Color(0xFF9E9E9E),
      ),
      child: Container(),
    );
  }

  List<Widget> _buildNotches() {
    return widget.notchGroups!.map((group) {
      // Normalize notch position as a percentage along the arc
      double normalizedPosition;

      if (group.stepIndex != null) {
        normalizedPosition = group.stepIndex! / widget.steps;
      } else {
        normalizedPosition =
            SliderUtils.normalize(widget.min, widget.max, group.value!);
      }

      // Calculate the notch's position in radians
      final notchRadian = SliderUtils.lerp(
        widget.startAngle,
        widget.endAngle,
        normalizedPosition,
      );

      // Adjust with offsetRadian and normalize to [0, 2pi]
      final adjustedRadian =
          (notchRadian + widget.offsetRadian) % (2 * math.pi);

      return CustomPaint(
        painter: SliderNotchPainter(
          notches: group.notches,
          radius: widget.radius - widget.track.width + widget.notchRingOffset,
          radian: adjustedRadian,
          spacing: group.spacing,
          offsetRadian:
              widget.offsetRadian, // Not needed in the painter anymore
        ),
        child: Container(),
      );
    }).toList();
  }

  List<Widget> _buildSegments() {
    final arcLength =
        SliderUtils.getRadianLength(widget.startAngle, widget.endAngle);

    return widget.segments!.map((segment) {
      return CustomPaint(
        painter: SliderTrackPainter(
          offsetRadian: widget.offsetRadian,
          radius: widget.radius,
          strokeWidth: segment.width,
          startRadian: widget.startAngle + segment.start * arcLength,
          lengthRadian: segment.length * arcLength,
          color: segment.color,
          gradientColors: segment.gradientColors,
          gradientStops: segment.gradientStops,
          gradientMode: segment.gradientMode,
          strokeCap: segment.strokeCap,
        ),
        child: Container(),
      );
    }).toList();
  }

  List<Widget> _buildMarkers(Offset center) {
    return widget.markers!.map((marker) {
      // Normalize marker position as a percentage along the arc
      double normalizedPosition;

      if (marker.stepIndex != null) {
        normalizedPosition = marker.stepIndex! / widget.steps;
      } else {
        normalizedPosition =
            SliderUtils.normalize(widget.min, widget.max, marker.value!);
      }

      // Calculate the marker's position in radians
      final markerRadian = SliderUtils.lerp(
        widget.startAngle,
        widget.endAngle,
        normalizedPosition,
      );

      // Adjust with offsetRadian and normalize to [0, 2pi]
      final adjustedRadian =
          (markerRadian + widget.offsetRadian) % (2 * math.pi);

      final pos = SliderUtils.toPolar(
        center,
        adjustedRadian,
        widget.radius,
      );

      final tangentAngle = marker.lockRotation
          ? SliderUtils.getTangentAngle(center, pos, widget.radius)
          : 0.0;

      return Positioned(
        left: pos.dx - marker.size.width / 2,
        top: pos.dy - marker.size.height / 2,
        width: marker.size.width,
        height: marker.size.height,
        child: Transform.rotate(
          angle: tangentAngle,
          child: marker.marker,
        ),
      );
    }).toList();
  }

  Widget _buildKnob(Offset center) {
    final normalizedValue =
        SliderUtils.normalize(widget.min, widget.max, widget.value);

    // Calculate the knob's position in radians
    final knobRadian = SliderUtils.lerp(
      widget.startAngle,
      widget.endAngle,
      normalizedValue,
    );

    // Adjust with offsetRadian and normalize to [0, 2pi]
    final adjustedRadian = (knobRadian + widget.offsetRadian) % (2 * math.pi);

    final effectiveRadius = widget.radius * widget.knobAlignment;

    final pos = SliderUtils.toPolar(
      center,
      adjustedRadian,
      effectiveRadius,
    );

    final tangentAngle =
        SliderUtils.getTangentAngle(center, pos, effectiveRadius);

    return Positioned(
      left: pos.dx - widget.knobSize.width / 2,
      top: pos.dy - widget.knobSize.height / 2,
      width: widget.knobSize.width,
      height: widget.knobSize.height,
      child: Builder(builder: (context) {
        Widget knob = widget.knobBuilder(
          context,
          adjustedRadian,
        );

        if (widget.interactionMode.hasKnob) {
          knob = GestureDetector(
            onPanStart: _handleKnobPanStart,
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            child: knob,
          );
        }

        if (widget.lockKnobRotation) {
          knob = Transform.rotate(
            angle: tangentAngle,
            child: knob,
          );
        }

        return knob;
      }),
    );
  }
}
