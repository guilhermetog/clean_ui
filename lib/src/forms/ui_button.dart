import 'dart:math';

import 'package:flutter/material.dart';

import '../images/ui_icon.dart';
import '../layout/ui_row.dart';
import '../ui_core/plug.dart';
import '../ui_text.dart';

enum IconSide { left, right }

class UIButton extends UIRow {
  bool bordered = false;
  IconData? icon;
  IconSide iconSide = IconSide.left;
  String label = 'Button';

  bool _isLocked = false;

  Plug onClick = Plug();

  _click() {
    if (!_isLocked) {
      onClick();
    }
  }

  lock() {
    _isLocked = true;
  }

  unlock() {
    _isLocked = false;
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    onTap.then(_click);
    borderRadius = BorderRadius.circular(pHeight(12));
    final color = this.color!.withAlpha(_isLocked ? 100 : 255);
    border = bordered ? Border.all(color: color, width: pHeight(4)) : null;
    mainAxisAlignment = MainAxisAlignment.spaceBetween;
    crossAxisAlignment = CrossAxisAlignment.center;

    if (bordered) {
      this.color = Colors.transparent;
    }

    return [
      if (icon != null && iconSide == IconSide.left)
        UIcon()
          ..size = pWidth(15)
          ..icon = icon!
          ..color = bordered ? color : Colors.white
      else
        SizedBox(width: pWidth(15), height: pHeight(15)),
      UIText()
        ..text = label
        ..fontSize = pHeight(27)
        ..textColor = bordered ? color : Colors.white,
      if (icon != null && iconSide == IconSide.right)
        UIcon()
          ..size = min(pWidth(15), pHeight(80))
          ..icon = icon!
          ..color = bordered ? color : Colors.white
      else
        SizedBox(width: pWidth(15), height: pHeight(15)),
    ];
  }
}
