import 'package:flutter/material.dart';
import '../canvas_component.dart';

class CanvasRect extends CanvasComponent {
  @override
  void customDraw(Canvas canvas) {
    if (fill != Colors.transparent) {
      canvas.drawRect(Rect.fromLTWH(0, 0, pWidth(100), pHeight(100)),
          Paint()..color = fill);
    }
    if (stroke != Colors.transparent) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, pWidth(100), pHeight(100)),
          Paint()
            ..color = stroke
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth);
    }
  }
}
