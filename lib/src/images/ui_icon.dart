import 'package:flutter/material.dart';

import '../super_components/ui_component.dart';

class UIcon extends UIComponent {
  IconData icon = Icons.question_mark;
  Color? _color = Colors.white;

  set size(double? value) {
    height = value;
    width = value;
  }

  double? get size => height ?? width;

  @override
  set color(Color? value) => _color = value;

  @override
  Widget buildChild(BuildContext context) {
    return Icon(
      icon,
      color: _color,
      size: pHeight(100),
    );
  }
}
