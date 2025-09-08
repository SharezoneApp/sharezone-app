// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// {@template clock_widget}
/// A custom-rendered analog clock widget that displays a fixed time.
///
/// It supports a "catching up" animation to synchronize with
/// the current time.
///
/// Tapping the clock will stop or start its animation.
///
/// This widget uses a [LeafRenderObjectWidget] to create a [ClockRenderBox]
/// for efficient custom painting and animation.
/// {@endtemplate}
@immutable
class EasterEggClock extends LeafRenderObjectWidget {
  /// {@macro clock_widget}
  const EasterEggClock({
    this.dimension = double.infinity,
    this.animationDuration = const Duration(seconds: 2),
    this.idleTime,
    super.key,
  });

  /// The desired size (width and height) of the clock.
  ///
  /// If set to [double.infinity], the clock will expand to fill the available space.
  final double dimension;

  /// Duration for the catching up animation.
  final Duration animationDuration;

  /// The time to display on the clock when it's idle.
  final DateTime? idleTime;

  @override
  RenderObject createRenderObject(BuildContext context) => ClockRenderBox(
    dimension: dimension,
    animationDuration: animationDuration,
    idleTime: idleTime,
  );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant ClockRenderBox renderObject,
  ) {
    renderObject.dimension = dimension;
    renderObject._animator.animationDuration = animationDuration;
    renderObject._animator.idleTime = idleTime;
  }
}

/// Default time used when no idle time is provided. It's like a smile.
final defaultIdleTime = DateTime(2025, 1, 1, 1, 50, 22);

/// A custom [RenderBox] that lays out and paints an analog clock.
///
/// This class manages the animation loop via a [Ticker] and delegates the
/// actual drawing to specialized painter classes for different parts of the clock
/// (dial, hands, and center). This separation of concerns and caching of static
/// parts (`Picture`) ensures high performance.
class ClockRenderBox extends RenderBox {
  /// Creates a [ClockRenderBox].
  ///
  /// Initializes the painters responsible for drawing different parts of the clock.
  ClockRenderBox({
    required double dimension,
    required Duration animationDuration,
    DateTime? idleTime,
  }) : _dimension = dimension,
       _dialPainter = _DialPainter(),
       _handsPainter = _HandsPainter(),
       _centerPainter = _CenterPainter() {
    _animator = _ClockAnimator(
      onUpdate: markNeedsPaint,
      idleTime: idleTime ?? defaultIdleTime,
      animationDuration: animationDuration,
    );
  }

  double _dimension;
  double get dimension => _dimension;
  set dimension(double value) {
    if (_dimension == value) {
      return;
    }
    _dimension = value;
    markNeedsLayout();
  }

  /// Painter for the static clock face (dial and ticks).
  final _DialPainter _dialPainter;

  /// Painter for the dynamic clock hands.
  final _HandsPainter _handsPainter;

  /// Painter for the central circle, drawn on top of the hands.
  final _CenterPainter _centerPainter;

  /// The animator responsible for managing the clock's state and animation.
  late final _ClockAnimator _animator;

  @override
  double computeMinIntrinsicWidth(double height) {
    if (_dimension.isFinite) {
      return _dimension;
    }
    // If dimension is infinite, our width is determined by the height constraint.
    return height.isFinite ? height : 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (_dimension.isFinite) {
      return _dimension;
    }
    // If dimension is infinite, our width is determined by the height constraint.
    return height.isFinite ? height : double.infinity;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (_dimension.isFinite) {
      return _dimension;
    }
    return width.isFinite ? width : 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (_dimension.isFinite) {
      return _dimension;
    }
    return width.isFinite ? width : double.infinity;
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (_dimension.isFinite) {
      return constraints.constrain(Size.square(_dimension));
    }
    // When dimension is infinite, expand to fit the constraints, but as a square.
    final side = constraints.biggest.shortestSide;
    if (side.isInfinite) {
      // If both width and height are unbounded, we can't size ourselves.
      // Fall back to the smallest possible size.
      return constraints.smallest;
    }
    return constraints.constrain(Size.square(side));
  }

  @override
  void performLayout() {
    // Set the size of the render box to the biggest available space or the specified dimension.
    size = computeDryLayout(constraints);

    // Prepare painters with the new size. This pre-calculates layouts and caches static drawings.
    _dialPainter.prepare(size);
    _handsPainter.prepare(size);
    _centerPainter.prepare(size);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animator.muted = false;
  }

  @override
  void detach() {
    super.detach();
    _animator.muted = true;
  }

  @override
  void dispose() {
    super.dispose();
    _animator.dispose();
    _dialPainter.dispose();
    _handsPainter.dispose();
    _centerPainter.dispose();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas =
        context.canvas
          ..save()
          ..translate(offset.dx, offset.dy)
          ..clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Paint the clock parts in the correct order (layers).
    _dialPainter.paint(canvas);

    final angles = _animator.currentAngles;
    _handsPainter.paint(
      canvas,
      size,
      hourAngle: angles.hour,
      minuteAngle: angles.minute,
      secondAngle: angles.second,
    );

    // Paint the center circle on top of the hands.
    _centerPainter.paint(canvas);

    canvas.restore();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      false;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is! PointerDownEvent) return;
    if (_animator.state != _ClockState.idle) {
      _animator.stop();
    } else {
      _animator.start();
    }
  }
}

/// A mixin that provides shared properties and methods for clock part painters.
///
/// This helps to centralize common drawing logic and constants, such as colors
/// and radius calculations.
mixin _ClockPainterMixin {
  /// Colors used in the clock.
  static const pinkColor = Color(0xffff5876);
  static const grayColor = Color(0xFF405B6C);
  static const blueColor = Color(0xff86dcff);
  static const lightGrayColor = Color(0xffe4eef9);

  double _clockRadius = 0;

  /// Radius of the clock, used for size-dependent calculations.
  double get clockRadius => _clockRadius;

  /// Pre-calculates size-dependent properties.
  /// This is called whenever the clock's size changes.
  @mustCallSuper
  void prepare(Size size) {
    _clockRadius = size.shortestSide / 2;
  }

  /// Releases resources held by the painter.
  void dispose() {}

  /// Draws an inner shadow for a circular shape on the canvas.
  @protected
  void drawInnerShadow(Canvas canvas, double radius, double shadowSize) {
    final shadowPaint = Paint()..color = Colors.black12;

    // Create a shadow effect by subtracting a slightly translated circle from the main one.
    final outer =
        Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));

    // The inner circle is translated upwards to create a "cutout", resulting in a shadow at the top edge.
    final inner =
        Path()..addOval(
          Rect.fromCircle(
            center: Offset.zero,
            radius: radius,
          ).translate(0, -shadowSize),
        );

    // The difference between the two paths creates the shadow shape.
    canvas.drawPath(
      Path.combine(PathOperation.difference, outer, inner),
      shadowPaint,
    );
  }
}

/// A painter responsible for drawing the clock's dial.
///
/// The dial is static and only changes when the size changes, so we cache it as a [Picture] for performance.
class _DialPainter with _ClockPainterMixin {
  /// A cached Picture of the dial to optimize performance.
  Picture? _dialPicture;

  @override
  void prepare(Size size) {
    super.prepare(size);
    _dialPicture?.dispose();
    _dialPicture = null;

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder)..translate(size.width / 2, size.height / 2);

    final innerRadius = clockRadius * 0.835;

    final hourTickLength = clockRadius * 0.093;

    final tickPaint =
        Paint()
          ..color = _ClockPainterMixin.grayColor
          ..strokeWidth = clockRadius * 0.062
          ..strokeCap = StrokeCap.round;

    /// Records the main dial face (background circles and shadows).
    canvas
      ..drawCircle(
        Offset.zero,
        clockRadius,
        Paint()..color = _ClockPainterMixin.pinkColor,
      )
      ..drawCircle(
        Offset.zero,
        innerRadius,
        Paint()..color = _ClockPainterMixin.lightGrayColor,
      );

    drawInnerShadow(canvas, clockRadius, clockRadius * 0.08);
    drawInnerShadow(canvas, innerRadius, innerRadius * 0.08);

    /// Records the hour ticks.
    final tickRadius = clockRadius * 0.73;
    for (var h = 0; h < 12; h += 3) {
      final angle = -math.pi / 2 + h * math.pi / 6;

      final p1 = Offset(
        (tickRadius - hourTickLength) * math.cos(angle),
        (tickRadius - hourTickLength) * math.sin(angle),
      );

      final p2 = Offset(
        tickRadius * math.cos(angle),
        tickRadius * math.sin(angle),
      );

      canvas.drawLine(p1, p2, tickPaint);
    }
    _dialPicture = recorder.endRecording();
  }

  /// Paints the cached dial picture onto the canvas.
  void paint(Canvas canvas) {
    if (_dialPicture case Picture picture) {
      canvas.drawPicture(picture);
    }
  }

  @override
  void dispose() {
    _dialPicture?.dispose();
    _dialPicture = null;
  }
}

/// A painter for the central circle, drawn on top of the hands.
class _CenterPainter with _ClockPainterMixin {
  Picture? _centerPicture;

  @override
  void prepare(Size size) {
    super.prepare(size);
    _centerPicture?.dispose();
    _centerPicture = null;

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder)..translate(size.width / 2, size.height / 2);

    final centerRadius = clockRadius * 0.11;
    canvas.drawCircle(
      Offset.zero,
      centerRadius,
      Paint()..color = _ClockPainterMixin.pinkColor,
    );
    drawInnerShadow(canvas, centerRadius, centerRadius * 0.75);
    _centerPicture = recorder.endRecording();
  }

  /// Paints the cached center circle picture onto the canvas.
  void paint(Canvas canvas) {
    if (_centerPicture case Picture picture) {
      canvas.drawPicture(picture);
    }
  }

  @override
  void dispose() {
    _centerPicture?.dispose();
    _centerPicture = null;
  }
}

/// A painter responsible for drawing the clock's hands (hour, minute, and second).
///
/// This painter handles the dynamic elements of the clock that change over time.
/// It pre-calculates size-dependent properties in `prepare` to optimize the `paint` method.
class _HandsPainter with _ClockPainterMixin {
  late Paint _hourHandPaint;

  /// Paint for the minute hand.
  late Paint _minuteHandPaint;

  /// Paint for the second hand.
  late Paint _secondHandPaint;

  /// Length of the hour hand.
  double _hourHandLength = 0;

  /// Length of the minute hand.
  double _minuteHandLength = 0;

  /// Length of the second hand.
  double _secondHandLength = 0;

  /// Pre-calculates size-dependent properties like hand lengths and paint styles.
  ///
  /// This is called whenever the clock's size changes to avoid expensive calculations
  /// during the frequent paint calls.
  @override
  void prepare(Size size) {
    super.prepare(size);

    _hourHandLength = clockRadius * 0.36;
    _minuteHandLength = clockRadius * 0.54;
    _secondHandLength = clockRadius * 0.58;

    _hourHandPaint =
        Paint()
          ..color = _ClockPainterMixin.grayColor
          ..strokeWidth = clockRadius * 0.12
          ..strokeCap = StrokeCap.round;

    _minuteHandPaint =
        Paint()
          ..color = _ClockPainterMixin.grayColor
          ..strokeWidth = clockRadius * 0.12
          ..strokeCap = StrokeCap.round;

    _secondHandPaint =
        Paint()
          ..color = _ClockPainterMixin.blueColor
          ..strokeWidth = clockRadius * 0.06
          ..strokeCap = StrokeCap.round;
  }

  /// Paints the clock hands on the canvas for a given date.
  void paint(
    Canvas canvas,
    Size size, {
    required double hourAngle,
    required double minuteAngle,
    required double secondAngle,
  }) {
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      // hour hand.
      ..drawLine(
        Offset.zero,
        Offset(
          _hourHandLength * math.cos(hourAngle),
          _hourHandLength * math.sin(hourAngle),
        ),
        _hourHandPaint,
      )
      // minute hand.
      ..drawLine(
        Offset.zero,
        Offset(
          _minuteHandLength * math.cos(minuteAngle),
          _minuteHandLength * math.sin(minuteAngle),
        ),
        _minuteHandPaint,
      )
      // second hand.
      ..drawLine(
        Offset.zero,
        Offset(
          _secondHandLength * math.cos(secondAngle),
          _secondHandLength * math.sin(secondAngle),
        ),
        _secondHandPaint,
      )
      ..restore();
  }
}

/// The animation state of the clock.
enum _ClockState {
  /// The clock is stopped and showing the initial time.
  idle,

  /// The clock is animating to catch up to the current time.
  catchingUp,

  /// The clock is running and synchronized with the current time.
  running,
}

/// A helper class to manage the animation state and logic for the clock.
///
/// This class encapsulates the ticker, animation states (idle, catching up, running),
/// and the calculation of hand angles, separating the animation logic from the
/// rendering logic in [ClockRenderBox].
class _ClockAnimator {
  _ClockAnimator({
    required this.onUpdate,
    required DateTime idleTime,
    required Duration animationDuration,
  }) : _animationDuration = animationDuration,
       _idleTime = idleTime,
       _clockTime = idleTime;

  /// A callback to be invoked when the animator's state changes and a repaint is needed.
  final VoidCallback onUpdate;

  /// The time for the clock when idle, used for resetting.
  DateTime _idleTime;
  DateTime get idleTime => _idleTime;
  set idleTime(DateTime? time) {
    if (_idleTime == time) {
      return;
    }
    _idleTime = time ?? defaultIdleTime;
    _clockTime = time ?? defaultIdleTime;
    _state = _ClockState.idle;
    _progress = 0.0;
    onUpdate();
  }

  /// The current time displayed by the clock.
  DateTime _clockTime;

  /// The ticker that drives the animation.
  Ticker? _ticker;

  /// The current state of the clock's animation.
  _ClockState _state = _ClockState.idle;
  _ClockState get state => _state;

  // Animation state for the "catching up" animation.
  DateTime _animationStartTime = DateTime.now();

  /// Duration for the catching up animation.
  Duration _animationDuration;
  Duration get animationDuration => _animationDuration;
  set animationDuration(Duration value) {
    if (_animationDuration == value) {
      return;
    }
    _animationDuration = value;
    if (_state == _ClockState.catchingUp) {
      _progress = 0;
      onUpdate();
    }
  }

  /// Progress of the animation.
  double _progress = 0;

  // Start, target, and current angles for the hands animation.
  Animatable<double>? _hourTween, _minuteTween, _secondTween;

  /// Whether this ticker has been silenced.
  ///
  /// While silenced, a ticker's clock can still run, but the callback will not
  /// be called.
  set muted(bool value) => _ticker?.muted = value;
  bool get muted => _ticker?.muted ?? true;

  /// Returns the current angles of the clock hands.
  ({double hour, double minute, double second}) get currentAngles =>
      switch (_state) {
        _ClockState.running => _getAnglesFromTime(_clockTime),
        _ClockState.catchingUp => (
          hour: _hourTween!.transform(_progress),
          minute: _minuteTween!.transform(_progress),
          second: _secondTween!.transform(_progress),
        ),
        _ClockState.idle => _getAnglesFromTime(_idleTime),
      };

  /// Calculates the angles for each hand based on a given [DateTime].
  ({double hour, double minute, double second}) _getAnglesFromTime(
    DateTime time,
  ) {
    final hour = time.hour;
    final minute = time.minute;
    final second = time.second + time.millisecond / 1000.0;

    // Calculate the angle for each hand.
    // The starting point is -pi/2 radians (12 o'clock).
    final hourAngle =
        -math.pi / 2 + (hour % 12 + minute / 60 + second / 3600) * math.pi / 6;
    // A minute/second step is pi/30 radians (6 degrees).
    final minuteAngle = -math.pi / 2 + (minute + second / 60) * math.pi / 30;
    final secondAngle = -math.pi / 2 + second * math.pi / 30;

    return (hour: hourAngle, minute: minuteAngle, second: secondAngle);
  }

  Animatable<double> _createAngleTween(double begin, double end) {
    var targetAngle = end;
    // Ensure the animation always moves clockwise by adding a full circle (2 * pi)
    // if the target angle is smaller than the beginning angle.
    if (targetAngle < begin) {
      targetAngle += 2 * math.pi;
    }
    return Tween<double>(
      begin: begin,
      end: targetAngle,
    ).chain(CurveTween(curve: Curves.easeInOut));
  }

  /// Starts the clock animation.
  ///
  /// Transitions the clock from the `idle` state to `catchingUp`, initiating
  /// a [animationDuration] animation to synchronize with the current time.
  void start() {
    if (_state != _ClockState.idle) return;
    _animationStartTime = DateTime.now();
    final targetTime = _animationStartTime.add(_animationDuration);

    // 1. Get the initial angles of the hands.
    //    These are the angles corresponding to the time the clock showed before
    //    the animation started (_idleTime). They serve as the starting point for the animation.
    final startAngles = _getAnglesFromTime(_clockTime);

    // 2. Calculate the target angles.
    //    These are the angles the hands should be at by the end of the animation.
    //    They correspond to `targetTime`, which is the current time plus the animation duration.
    final targetAngles = _getAnglesFromTime(targetTime);

    // 3. Create tweens for each hand for a smooth transition from the start to the target angle.
    //    The `_createAngleTween` method is important as it ensures the hands always move
    //    clockwise, even if it's the "long way around" (e.g., from 11 to 1).
    _hourTween = _createAngleTween(startAngles.hour, targetAngles.hour);
    _minuteTween = _createAngleTween(startAngles.minute, targetAngles.minute);
    _secondTween = _createAngleTween(startAngles.second, targetAngles.second);

    _state = _ClockState.catchingUp;
    _ticker ??= Ticker(_onTick);
    _ticker?.start();
  }

  /// Stops the clock animation and resets it to the idle time.
  ///
  /// Transitions the clock to the `idle` state.
  void stop() {
    if (_state == _ClockState.idle) return;
    _state = _ClockState.idle;
    _ticker?.stop();
    _clockTime = _idleTime;
    _progress = 0.0;
    onUpdate();
  }

  /// Called by the ticker on each frame to update the animation state.
  void _onTick(Duration elapsed) {
    final now = DateTime.now();
    switch (_state) {
      case _ClockState.idle:
        break;
      case _ClockState.catchingUp:
        final animationElapsed = now.difference(_animationStartTime);
        if (animationElapsed >= _animationDuration) {
          _state = _ClockState.running;
          _clockTime = now;
          _progress = 1;
          onUpdate();
        } else {
          _progress =
              animationElapsed.inMicroseconds /
              _animationDuration.inMicroseconds;
          onUpdate();
        }
        break;
      case _ClockState.running:
        _clockTime = now;
        onUpdate();
        break;
    }
  }

  /// Releases the resources used by this animator.
  void dispose() {
    _ticker?.dispose();
  }
}
