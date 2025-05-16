import 'package:flutter/material.dart';
import '../canvas_component.dart';

class CanvasText extends CanvasComponent {
  double fontSize = 24;
  String text = '';

  @override
  void customDraw(Canvas canvas) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: stroke,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(0, -textPainter.height / 2));
  }
}
