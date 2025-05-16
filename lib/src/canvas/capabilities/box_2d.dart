import 'dart:ui';
import '../canvas_component.dart';

mixin Box2D on CanvasComponent {
  double _width = 0;
  double _height = 0;

  @override
  set height(double? value) {
    _height = value ?? 0;
    super.height = value;
  }

  @override
  set width(double? value) {
    _width = value ?? 0;
    super.width = value;
  }

  double get _left => left - _width / 2;
  double get _right => left + _width / 2;
  double get _top => top - _height / 2;
  double get _bottom => top + _height / 2;

  Rect get mainBox => Rect.fromLTRB(_left, _top, _right, _bottom);

  bool collidesWith(Box2D other) {
    return mainBox.overlaps(other.mainBox);
  }

  bool containsPoint(double px, double py) {
    return mainBox.contains(Offset(px, py));
  }
}
