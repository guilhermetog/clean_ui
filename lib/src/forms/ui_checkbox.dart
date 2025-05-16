import 'package:flutter/material.dart';

import '../images/ui_icon.dart';
import '../layout/ui_stack.dart';
import '../ui_core/plug.dart';
import '../ui_core/ui_core.dart';
import "../super_components/ui_component.dart";

class UICheckbox extends UIComponent with UIState {
  bool _checked = false;

  Plug<bool> onChange = Plug();

  set size(double value) {
    super.height = value;
    super.width = value;
  }

  set checked(bool value) {
    _checked = value;
  }

  _toggle() {
    _checked = !_checked;
    onChange.send(_checked);
    render();
  }

  @override
  Widget buildChild(BuildContext context) {
    return UIStack()
      ..height = pHeight(90)
      ..width = pWidth(90)
      ..onTap.then(_toggle)
      ..children = [
        UIComponent()
          ..height = pHeight(90)
          ..width = pWidth(90)
          ..border = Border.all(color: Colors.black, width: pHeight(2)),
        if (_checked)
          UIcon()
            ..size = pHeight(80)
            ..icon = Icons.check
            ..color = Colors.green,
      ];
  }
}
