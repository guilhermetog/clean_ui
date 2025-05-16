// import 'package:flutter/material.dart';
// import 'package:lesson1/uicomponent/canvas/ui_canvas.dart';

// enum Anchor {
//   topLeft,
//   topCenter,
//   topRight,
//   centerLeft,
//   center,
//   centerRight,
//   bottomLeft,
//   bottomCenter,
//   bottomRight,
// }

// class CanvasComponent extends UICanvas {
//   double width = 0;
//   double height = 0;
//   double _top = 0;
//   double _left = 0;
//   double _topOffset = 0;
//   double _leftOffset = 0;

//   @override
//   set top(double value) => _top = value;
//   @override
//   set left(double value) => _left = value;
//   @override
//   double get top => _top + _topOffset;
//   @override
//   double get left => _left + _leftOffset;

//   double rotation = 0.0;
//   bool flipX = false;
//   bool flipY = false;

//   Anchor anchor = Anchor.topLeft;
//   Color fill = Colors.transparent;
//   Color stroke = Colors.transparent;
//   double strokeWidth = 1;

//   void prepareCanvas(Canvas canvas) {
//     Offset adjustedOffset = _calculateAnchorOffset();
//     canvas.save();
//     canvas.translate(adjustedOffset.dx, adjustedOffset.dy);
//     if (rotation != 0) canvas.rotate(rotation);
//     if (flipX || flipY) canvas.scale(flipX ? -1.0 : 1.0, flipY ? -1.0 : 1.0);
//   }

//   Offset _calculateAnchorOffset() {
//     double dx = left;
//     double dy = top;
//     // handle anchor positions
//     return Offset(dx, dy);
//   }
// }
