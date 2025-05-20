import 'package:flutter/material.dart';

import '../ui_core/plug.dart';
import '../ui_core/ui_animation.dart';
import '../ui_core/ui_core.dart';

class UILayout extends UICore {
  late UIAnimation animation;
  late BuildContext context;
  Size? _size;
  double? width;
  double? height;
  double? _screenHeight;
  double? _screenWidth;
  double? _screenHeightSafe;
  double? _paddingTop;
  double? _paddingBottom;
  double? _top;
  double? _left;
  double? _right;
  double? _bottom;

  UILayout([super.name]);

  double get paddingTop {
    _paddingTop ??= (MediaQuery.of(context).padding.top).ceilToDouble();
    return _paddingTop!;
  }

  double get paddingBottom {
    _paddingBottom ??= (MediaQuery.of(context).padding.bottom).toDouble();
    return _paddingBottom!;
  }

  double get viewInsetBottom {
    return (MediaQuery.of(context).viewInsets.bottom).toDouble();
  }

  double screenWidth(double percentage) {
    if (_screenWidth == null || _screenWidth == double.infinity) {
      _screenWidth = MediaQuery.of(context).size.width;
    }
    return (_screenWidth! * (percentage / 100)).toDouble();
  }

  double screenHeight(double percentage, {bool safe = false}) {
    double margins = 0;

    if (safe) {
      margins = paddingTop + paddingBottom;
      if (_screenHeightSafe == null || _screenHeightSafe == double.infinity) {
        _screenHeightSafe ??= (MediaQuery.of(context).size.height - margins);
      }
      return (_screenHeightSafe! * (percentage / 100)).toDouble();
    } else {
      if (_screenHeight == null || _screenHeight == double.infinity) {
        _screenHeight ??= MediaQuery.of(context).size.height;
      }
      return (_screenHeight! * (percentage / 100)).toDouble();
    }
  }

  double pWidth(double percentage) {
    if (_size == null) return 0;
    return (_size!.width * (percentage / 100)).toDouble();
  }

  double pHeight(double percentage) {
    if (_size == null) return 0;
    return (_size!.height * (percentage / 100)).toDouble();
  }

  set top(double value) => _top = value;
  double get top {
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero).dy;
  }

  set left(double value) => _left = value;
  double get left {
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero).dx;
  }

  set bottom(double value) => _bottom = value;
  double get bottom {
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero).dy + renderBox.size.height;
  }

  set right(double value) => _right = value;
  double get right {
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width;
  }

  bool get isPositioned =>
      _top != null || _left != null || _right != null || _bottom != null;

  double font(double percentage) {
    return pWidth(percentage) / (pWidth(30) / pHeight(100));
  }

  @override
  Widget buildLayout(BuildContext context) {
    LayoutBuilder builder = LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.biggest.height == MediaQuery.of(context).size.height) {
          _size = Size(
            width ?? constraints.biggest.width,
            height ??
                constraints.biggest.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
          );
        } else {
          _size = Size(
            width ?? constraints.biggest.width,
            height ?? constraints.biggest.height,
          );
        }

        this.context = context;
        return buildComponent(context);
      },
    );

    if (isPositioned) {
      return Positioned(
        top: _top,
        left: _left,
        right: _right,
        bottom: _bottom,
        child: builder,
      );
    } else {
      return builder;
    }
  }

  Widget buildComponent(BuildContext context) {
    return const SizedBox.shrink();
  }
}

mixin UIOverlay on UILayout {
  late OverlayEntry _overlayEntry;
  bool _isMounted = false;

  Plug onOpen = Plug();

  open(BuildContext context) {
    this.context = context;
    if (!_isMounted) {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Stack(fit: StackFit.expand, children: [this]),
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry);
      _isMounted = true;
      onOpen();
    }
  }

  close() {
    if (_isMounted) {
      _overlayEntry.remove();
      _isMounted = false;
    }
  }
}
