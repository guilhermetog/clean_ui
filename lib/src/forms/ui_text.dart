// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import '../super_components/ui_component.dart';
import '../ui_core/ui_core.dart';

class UIText extends UIComponent with UIState, UIAnimated {
  String text = '';
  TextStyle? style;
  Color? textColor;
  double? fontSize;
  FontWeight? fontWeight;
  TextDecoration? decoration;
  @override
  Alignment alignment = Alignment.centerLeft;

  @override
  BoxFit fit = BoxFit.none;

  UIText([super.name]);
  @override
  Widget buildChild(BuildContext context) {
    return Text(text, style: _styleProcessor(style));
  }

  TextStyle _styleProcessor(TextStyle? textStyle) {
    TextStyle defaultStyle = TextStyle(
      decoration: decoration ?? TextDecoration.none,
      decorationColor: textColor,
      color: textColor ?? Colors.black,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight,
      height: 1,
      fontFamily: 'Roboto',
    );
    if (textStyle == null) return defaultStyle;

    return textStyle.merge(defaultStyle);
  }
}
