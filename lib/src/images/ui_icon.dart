import 'package:flutter/material.dart';

import '../super_components/ui_component.dart';

class UIcon extends UIComponent {
  IconData icon = Icons.question_mark;
  Color? iconColor = Colors.white;

  set size(double? value) {
    height = value;
    width = value;
  }

  double? get size => height ?? width;

  @override
  Widget buildChild(BuildContext context) {
    return Icon(icon, color: iconColor, size: pHeight(100));
  }
}
