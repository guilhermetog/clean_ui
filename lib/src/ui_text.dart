// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'super_components/ui_component.dart';
import 'ui_core/ui_core.dart';

class UIText extends UIComponent with UIState, UIAnimated {
  String text = '';
  TextStyle? style;
  Color? textColor;
  double? fontSize;
  FontWeight? fontWeight;
  TextAlign? textAlign;
  TextDecoration? decoration;
  bool _blockWidth = false;
  bool _blockHeight = false;
  @override
  Alignment alignment = Alignment.centerLeft;

  @override
  set width(double? value) {
    _blockWidth = true;
    super.width = value;
  }

  @override
  set height(double? value) {
    _blockHeight = true;
    super.height = value;
  }

  UIText([super.name]);
  @override
  Widget buildChild(BuildContext context) {
    final fSize = fontSize ?? style?.fontSize;

    if (fSize == null) {
      fit = BoxFit.contain;
      fontSize = pHeight(100);
    } else if (!_blockHeight && !_blockWidth) {
      display = DisplayType.flex;
    } else if (!_blockWidth) {
      display = DisplayType.flexHorizontal;
    } else if (!_blockHeight) {
      display = DisplayType.flexVertical;
    }

    alignment = textAlign?.toAligment() ?? alignment;

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(text: text, style: _styleProcessor(style)),
    );
  }

  TextStyle _styleProcessor(TextStyle? textStyle) {
    TextStyle defaultStyle = TextStyle(
      decoration: decoration ?? TextDecoration.none,
      decorationColor: textColor,
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 1,
    );
    if (textStyle == null) return defaultStyle;

    return textStyle.merge(defaultStyle);
  }
}

extension on TextAlign {
  Alignment toAligment() {
    switch (this) {
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.justify:
        return Alignment.centerLeft;
      case TextAlign.start:
        return Alignment.topCenter;
      case TextAlign.end:
        return Alignment.topCenter;
    }
  }
}
