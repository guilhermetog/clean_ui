import 'dart:ui';

import 'package:flutter/material.dart';
import '../super_components/ui_component.dart';
import '../super_components/ui_layout.dart';
import '../ui_core/ui_core.dart';
import 'ui_stack.dart';

const double _defaultHeight = 30;

mixin UIModal on UIComponent {
  late _UIModal _kModal;
  double _height = _defaultHeight;
  final double _position = -_defaultHeight;

  setHeight(double value) {
    _height = value;
  }

  open(BuildContext context) {
    _kModal = _UIModal(modal: this);
    _kModal.open(context);
  }

  close() {
    _kModal.close();
  }
}

class _EmptyModal extends UIComponent with UIModal {}

class _UIModal extends UIStack with UIOverlay, UIState, UIAnimated {
  UIModal modal = _EmptyModal();
  double opacity = 0.6;
  double _height = _defaultHeight;
  double _position = -_defaultHeight;

  _UIModal({required this.modal}) {
    _height = modal._height;
    _position = modal._position;
  }

  @override
  onMount() {
    animation.create(
        name: "pop-up",
        duration: const Duration(milliseconds: 200),
        start: -_height,
        end: 50 - (_height / 2),
        onProgress: (data) {
          _position = data.progress;
          render();
        });
    animation.play("pop-up");
  }

  setHeight(double value) {
    _height = value;
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      UIComponent()
        ..height = screenHeight(100)
        ..width = screenWidth(100)
        ..onTap.then(close)
        ..color = Colors.transparent,
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: SizedBox(
          height: screenHeight(100),
          width: screenWidth(100),
        ),
      ),
      UIComponent()
        ..bottom = screenHeight(_position)
        ..left = pWidth(5)
        ..width = pWidth(90)
        ..height = screenHeight(_height)
        ..child = (modal
          ..height = screenHeight(_height)
          ..width = pWidth(90)),
    ];
  }
}
