import 'dart:ui';
import 'package:flutter/material.dart';
import '../canvas_component.dart';

class CanvasLine extends CanvasComponent {
  double x1 = 0;
  double y1 = 0;
  double x2 = 0;
  double y2 = 0;

  @override
  void customDraw(Canvas canvas) {
    canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..color = stroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth);
  }
}
