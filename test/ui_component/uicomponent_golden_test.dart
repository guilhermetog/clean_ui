import 'package:clean_ui/clean_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

main() {
  Color color = Colors.purple;

  testGoldens('UIComponent vazio', (WidgetTester tester) async {
    await tester.render(UIComponent()..color = color);
    await screenMatchesGolden(tester, 'ui_component_vazio');
  });

  testGoldens('UIComponent altura', (WidgetTester tester) async {
    await tester.render(
      UIComponent()
        ..color = color
        ..height = 100,
    );

    await screenMatchesGolden(tester, 'ui_component_altura');
  });

  testGoldens('UIComponent largura', (WidgetTester tester) async {
    await tester.render(
      UIComponent()
        ..color = color
        ..width = 100,
    );

    await screenMatchesGolden(tester, 'ui_component_largura');
  });

  testGoldens('UIComponent largura altura', (WidgetTester tester) async {
    await tester.render(
      UIComponent()
        ..color = color
        ..width = 100
        ..height = 100,
    );

    await screenMatchesGolden(tester, 'ui_component_largura_altura');
  });
}

extension on WidgetTester {
  Future<void> render(Widget widget) async {
    await pumpWidgetBuilder(Center(child: widget));
  }
}
