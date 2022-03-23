import 'dart:math';

import 'package:flutter/material.dart';

class ScanSelectionOverlay extends StatelessWidget {
  const ScanSelectionOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: ScanSelectionPainter(),
        ),
        const _ScanSelectionCorner(),
      ],
    );
  }
}

class ScanSelectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const radius = 200.0;
    const center = Offset(0, 0);
    final path = Path();
    path.fillType = PathFillType.evenOdd;
    path.addRect(Rect.largest);
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCircle(center: center, radius: radius / 2),
        const Radius.circular(radius / 10),
      ),
    );
    canvas.drawPath(path, Paint()..color = Colors.black.withOpacity(0.3));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _ScanSelectionCorner extends StatelessWidget {
  const _ScanSelectionCorner({
    Key? key,
    this.color = Colors.black,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          painter: CornerBorderPainter(color: color),
        ),
        Transform.rotate(
          angle: pi,
          child: CustomPaint(
            painter: CornerBorderPainter(
              color: color,
            ),
          ),
        ),
        Transform.rotate(
          angle: pi / 2,
          child: CustomPaint(
            painter: CornerBorderPainter(
              color: color,
            ),
          ),
        ),
        Transform.rotate(
          angle: pi / -2,
          child: CustomPaint(
            painter: CornerBorderPainter(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class CornerBorderPainter extends CustomPainter {
  CornerBorderPainter({
    this.color = Colors.black,
    this.strokeWidth = 7.5,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    const width = 200.0;

    const start = Offset(width / -2, width / -2);
    const radius = 20.0;
    const length = 15;

    canvas.drawLine(
      start + const Offset(0, radius),
      start + const Offset(0, radius + length),
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      start + const Offset(radius, 0),
      start + const Offset(radius + length, 0),
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: start + const Offset(radius, radius),
        radius: width / (width / 20),
      ),
      pi,
      pi / 2,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
