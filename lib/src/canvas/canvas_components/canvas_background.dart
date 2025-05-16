import 'package:flutter/material.dart';

import '../canvas_component.dart';

class CanvasBackground extends CanvasComponent {
  CanvasBackground() {
    fill = Colors.white;
  }

  @override
  void customDraw(Canvas canvas) {
    canvas.drawRect(
        Rect.fromLTWH(0, 0, pWidth(100), pHeight(100)), Paint()..color = fill);
  }
}
