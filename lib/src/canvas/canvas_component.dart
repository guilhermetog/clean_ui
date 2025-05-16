import 'package:flutter/material.dart';
import '../ui_component.dart';
import 'controls/canvas_mouse_control.dart';

mixin UIBuffer {}

enum Anchor {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class CanvasComponent extends UIComponent with UIState, UIAnimated {
  final ValueNotifier<bool> _paintLoop = ValueNotifier(false);
  final List<CanvasComponent> _configChildren = [];
  final List<CanvasComponent> _drawChildren = [];
  bool _isSetup = true;
  bool _isRoot = false;
  bool _wasRemoved = false;
  bool _needRepaint = true;

  double rotation = 0.0;
  bool flipX = false;
  bool flipY = false;

  double _top = 0;
  double _left = 0;

  Anchor anchor = Anchor.topLeft;
  Color fill = Colors.transparent;
  Color stroke = Colors.transparent;
  double strokeWidth = 1;

  @override
  double get top => _isRoot ? super.top : _top;
  @override
  double get left => _isRoot ? super.left : _left;
  @override
  set top(double value) => _top = value;
  @override
  set left(double value) => _left = value;

  @override
  onMount() async {
    animation.create(
      name: 'loop',
      duration: const Duration(seconds: 1),
      repeat: true,
      onProgress: (_) => _repaint(),
    );

    animation.play('loop');
  }

  _repaint() {
    _paintLoop.value = !_paintLoop.value;
  }

  CanvasComponent paint(CanvasComponent parent) {
    parent._paint(this);

    return this;
  }

  _paint(CanvasComponent component) {
    component.context = context;
    component.width ??= pWidth(100);
    component.height ??= pHeight(100);
    if (component._isSetup) {
      component.setup();
      _isSetup = false;
    } else {
      component.update();
    }
    if (_isSetup) {
      _configChildren.add(component);
    } else {
      _drawChildren.add(component);
    }
  }

  _setup() {
    setup();
    _isSetup = false;
  }

  setup() {}

  update() {}

  @override
  render() {
    _needRepaint = true;
  }

  unrender() {
    _needRepaint = false;
  }

  _draw() {
    update();
    draw();
    for (var layer in _configChildren) {
      layer._draw();
    }

    for (var layer in _drawChildren) {
      layer._draw();
    }
  }

  draw() {}

  _customDraw(Canvas canvas) {
    prepareCanvas(canvas);
    customDraw(canvas);
    canvas.restore();
    for (var layer in _configChildren) {
      layer._customDraw(canvas);
    }

    for (var layer in _drawChildren) {
      layer._customDraw(canvas);
    }

    if (this is! UIBuffer) {
      _drawChildren.clear();
    }
  }

  customDraw(Canvas canvas) {}

  void prepareCanvas(Canvas canvas) {
    Offset adjustedOffset = _calculateAnchorOffset();
    canvas.save();
    canvas.translate(adjustedOffset.dx, adjustedOffset.dy);
    if (rotation != 0) canvas.rotate(rotation);
    if (flipX || flipY) canvas.scale(flipX ? -1.0 : 1.0, flipY ? -1.0 : 1.0);
  }

  Offset _calculateAnchorOffset() {
    double dx = 0;
    double dy = 0;
    switch (anchor) {
      case Anchor.topLeft:
        break;
      case Anchor.topCenter:
        dx -= pWidth(50);
        break;
      case Anchor.topRight:
        dx -= pWidth(100);
        break;
      case Anchor.centerLeft:
        dy -= pHeight(50);
        break;
      case Anchor.center:
        dx -= pWidth(50);
        dy -= pHeight(50);
        break;
      case Anchor.centerRight:
        dx -= pWidth(100);
        dy -= pHeight(50);
        break;
      case Anchor.bottomLeft:
        dy -= pHeight(100);
        break;
      case Anchor.bottomCenter:
        dx -= pWidth(50);
        dy -= pHeight(100);
        break;
      case Anchor.bottomRight:
        dx -= pWidth(100);
        dy -= pHeight(100);
        break;
    }
    return Offset(dx, dy);
  }

  @override
  Widget buildChild(BuildContext context) {
    _isRoot = true;
    clipBehavior = Clip.hardEdge;
    CustomPaint paint = CustomPaint(
      painter: UIPainter(this, _paintLoop),
      size: Size(pWidth(100), pHeight(100)),
    );

    if (this is CanvasMouseControl) {
      return UIComponent()
        ..child = MouseRegion(
          onHover: (event) => (this as CanvasMouseControl).hoverEvent = event,
          child: GestureDetector(
            onTap: () => (this as CanvasMouseControl).tap(),
            onVerticalDragUpdate: (details) {
              (this as CanvasMouseControl).offset = details.localPosition;
              (this as CanvasMouseControl).drag();
            },
            onHorizontalDragUpdate: (_) => (this as CanvasMouseControl).drag(),
            child: paint,
          ),
        );
    } else {
      return UIComponent()..child = paint;
    }
  }
}

class UIPainter extends CustomPainter {
  CanvasComponent uiCanvas;
  int paintIndex = 0;

  UIPainter(this.uiCanvas, ValueNotifier paint) : super(repaint: paint);

  @override
  void paint(Canvas canvas, Size size) {
    if (paintIndex == 0) {
      uiCanvas._setup();
      paintIndex++;
    }

    if (uiCanvas._needRepaint) {
      uiCanvas._draw();
      uiCanvas._customDraw(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension ListManagement on List<CanvasComponent> {
  void delete(CanvasComponent component) {
    component._wasRemoved = true;
  }

  void refresh() {
    List<CanvasComponent> components = [];
    for (final component in this) {
      if (component._wasRemoved) {
        components.add(component);
      }
    }

    for (final component in components) {
      remove(component);
    }
  }
}
