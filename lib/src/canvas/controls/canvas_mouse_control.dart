import 'package:flutter/services.dart';
import '../canvas_component.dart';

mixin CanvasMouseControl on CanvasComponent {
  Offset _mouseOffset = Offset.zero;

  double get mouseX => _mouseOffset.dx;
  double get mouseY => _mouseOffset.dy;

  set hoverEvent(PointerHoverEvent? event) {
    _mouseOffset = (event?.position ?? Offset.zero).translate(-left, -top);
  }

  set offset(Offset offset) {
    _mouseOffset = offset;
  }

  tap() {}

  drag() {}

  updatePosition(Offset position) {}
}
