import 'dart:ui';

import 'package:flutter/material.dart';
import '../ui_core/plug.dart';
import '../ui_text.dart';
import 'ui_layout.dart';

enum DisplayType {
  column,
  row,
  container,
  flexVertical,
  flexHorizontal,
  flex,
  stack;

  bool get isSingleChild => this == container || isFlex;
  bool get isFlex =>
      this == flex || this == flexVertical || this == flexHorizontal;
  bool get hasSelfAligment => this == row || this == column || this == stack;

  bool get expandsHorizontally => this == flexHorizontal || this == flex;
  bool get expandsVertically => this == flexVertical || this == flex;
}

// ignore: must_be_immutable, use_key_in_widget_constructors
class UIComponent extends UILayout {
  EdgeInsets? padding;
  EdgeInsets? margin;
  Color? color;
  Gradient? gradient;
  Border? border;
  Offset? blur;
  BorderRadius? borderRadius;
  Alignment alignment = Alignment.center;
  BoxFit fit = BoxFit.none;
  List<BoxShadow>? boxShadow;
  Widget? child;
  List<Widget>? children;
  DisplayType display = DisplayType.container;
  Clip clipBehavior = Clip.none;
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;
  bool scroll = false;
  bool overflow = false;
  Axis? scrollDirection;
  bool wrap = false;
  DecorationImage? image;

  //interactive
  Plug onTap = Plug();
  Plug<DragStartDetails> onVerticalDragStart = Plug();
  Plug<DragUpdateDetails> onVerticalDragUpdate = Plug();
  Plug<DragEndDetails> onVerticalDragEnd = Plug();

  bool get _isInteractive =>
      onTap.isConnected ||
      onVerticalDragStart.isConnected ||
      onVerticalDragUpdate.isConnected ||
      onVerticalDragEnd.isConnected;

  bool get isATextExpansible => this is UIText && display.expandsHorizontally;

  UIComponent([super.name]);

  @override
  Widget buildUI(BuildContext context) {
    Widget? container;
    List<Widget>? children = buildChildren(context);

    if (children.isEmpty) {
      container = child ?? buildChild(context);
    } else {
      container = _solveList(children);
    }

    if (padding != null) {
      container = Padding(padding: padding!, child: container);
    }

    if (fit != BoxFit.none) {
      container = FittedBox(fit: fit, child: container);
    }
    if (!isATextExpansible && !display.hasSelfAligment) {
      container = Align(alignment: alignment, child: container);
    }

    if (clipBehavior != Clip.none) {
      container = ClipRRect(
          clipBehavior: clipBehavior,
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: container);
    }

    if (color != null ||
        border != null ||
        borderRadius != null ||
        boxShadow != null ||
        image != null ||
        gradient != null) {
      container = DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            border: border,
            borderRadius: borderRadius,
            boxShadow: boxShadow,
            image: image,
            gradient: gradient,
          ),
          child: container);
    }

    if (blur != null) {
      container = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur!.dx, sigmaY: blur!.dy),
          child: container);
    }

    if (scroll || overflow) {
      container = SingleChildScrollView(
          scrollDirection: scrollDirection ??
              (display == DisplayType.row ? Axis.horizontal : Axis.vertical),
          physics: overflow ? const NeverScrollableScrollPhysics() : null,
          child: container);
    }

    if (this is UIText) {
      container = Container(
        height: display.expandsVertically ? null : pHeight(100),
        width: display.expandsHorizontally ? null : pWidth(100),
        alignment: alignment,
        child: container,
      );
    } else if (pHeight(100).isValid && pWidth(100).isValid) {
      if (display.isFlex) {
        container = ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: pHeight(100),
            minWidth: pWidth(100),
            maxHeight:
                display.expandsVertically ? double.infinity : pHeight(100),
            maxWidth:
                display.expandsHorizontally ? double.infinity : pWidth(100),
          ),
          child: container,
        );
      } else {
        container = SizedBox(
            height: pHeight(100), width: pWidth(100), child: container);
      }
    }

    if (_isInteractive) {
      container = GestureDetector(
        onTap: onTap.isConnected ? onTap.call : null,
        onVerticalDragStart:
            onVerticalDragEnd.isConnected ? onVerticalDragStart.send : null,
        onVerticalDragUpdate:
            onVerticalDragUpdate.isConnected ? onVerticalDragUpdate.send : null,
        onVerticalDragEnd:
            onVerticalDragEnd.isConnected ? onVerticalDragEnd.send : null,
        child: container,
      );
    }

    if (margin != null) {
      container = Padding(padding: margin!, child: container);
    }

    return container;
  }

  Widget _solveList(List<Widget>? children) {
    switch (display) {
      case DisplayType.column:
        if (wrap) {
          return Wrap(
            alignment: mainAxisAlignment.toWrapAlignment(),
            direction: Axis.vertical,
            crossAxisAlignment: crossAxisAlignment.toWrapCrossAlignment(),
            children: this.children ?? children ?? [],
          );
        } else {
          return Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: this.children ?? children ?? [],
          );
        }
      case DisplayType.row:
        if (wrap) {
          return Wrap(
            alignment: mainAxisAlignment.toWrapAlignment(),
            direction: Axis.horizontal,
            crossAxisAlignment: crossAxisAlignment.toWrapCrossAlignment(),
            children: this.children ?? children ?? [],
          );
        } else {
          return Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: this.children ?? children ?? [],
          );
        }
      case DisplayType.stack:
        return Stack(
          clipBehavior: clipBehavior,
          alignment: alignment,
          children: this.children ?? children ?? [],
        );

      default:
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: this.children ?? children ?? [],
        );
    }
  }

  Widget buildChild(BuildContext context) {
    return const SizedBox.shrink();
  }

  List<Widget> buildChildren(BuildContext context) => children ?? [];
}

extension on MainAxisAlignment {
  WrapAlignment toWrapAlignment() {
    switch (this) {
      case MainAxisAlignment.start:
        return WrapAlignment.start;
      case MainAxisAlignment.center:
        return WrapAlignment.center;
      case MainAxisAlignment.end:
        return WrapAlignment.end;
      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }
}

extension on CrossAxisAlignment {
  WrapCrossAlignment toWrapCrossAlignment() {
    switch (this) {
      case CrossAxisAlignment.start:
        return WrapCrossAlignment.start;
      case CrossAxisAlignment.center:
        return WrapCrossAlignment.center;
      case CrossAxisAlignment.end:
        return WrapCrossAlignment.end;
      case CrossAxisAlignment.stretch:
        return WrapCrossAlignment.center;
      case CrossAxisAlignment.baseline:
        return WrapCrossAlignment.end;
    }
  }
}

extension on double? {
  bool get isValid =>
      this != null &&
      this != double.infinity &&
      this != double.negativeInfinity;
}
