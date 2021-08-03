import 'package:flutter/material.dart';

import '../../constants.dart';

class Background extends CustomPainter {
  final Color color;

  Background(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final Paint paint = Paint();

    final Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = color;
    canvas.drawPath(mainBackground, paint);

    final Path ovalPath = Path();
    ovalPath.moveTo(0, height * 0.1);
    ovalPath.quadraticBezierTo(
        width * 0.4, height * 0.1, width * 0.5, height * 0.45);

    ovalPath.quadraticBezierTo(width * 0.6, height * 0.8, 0, height * 0.95);

    ovalPath.close();

    paint.color = lighten(color);
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
