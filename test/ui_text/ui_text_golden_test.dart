import 'package:clean_ui/clean_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter/material.dart';

main() {
  Color color = Colors.purple;
  testGoldens('UIText vazio', (WidgetTester tester) async {
    await tester.render(UIText()..color = color);

    await screenMatchesGolden(tester, 'ui_text_vazio');
  });

  testGoldens('UIText texto vazio', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..color = color
        ..text = '',
    );

    await screenMatchesGolden(tester, 'ui_text_texto_vazio');
  });

  testGoldens('UIText texto', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..color = color
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_texto');
  });

  testGoldens('UIText altura largura', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_altura_largura');
  });

  testGoldens('UIText alinhamento top-left', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.topLeft
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_top_left');
  });

  testGoldens('UIText alinhamento top-right', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.topRight
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_top_right');
  });
  testGoldens('UIText alinhamento bottom-left', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.bottomLeft
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_bottom_left');
  });
  testGoldens('UIText alinhamento middle-left', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.centerLeft
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_middle_left');
  });
  testGoldens('UIText alinhamento middle-right', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.centerRight
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_middle_right');
  });
  testGoldens('UIText alinhamento bottom-center', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.bottomCenter
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_bottom_center');
  });
  testGoldens('UIText alinhamento top-center', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.topCenter
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_top_center');
  });
  testGoldens('UIText alinhamento center', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.center
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_center');
  });

  testGoldens('UIText alinhamento bottom-right', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..color = color
        ..alignment = Alignment.bottomRight
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_alinhamento_bottom_right');
  });

  testGoldens('UIText fontsize', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 100
        ..width = 100
        ..fontSize = 40
        ..color = color
        ..alignment = Alignment.center
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_fontsize');
  });

  testGoldens('UIText fit largura', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 200
        ..width = 100
        ..fontSize = 100
        ..fit = BoxFit.fitHeight
        ..color = color
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_fit_largura');
  });

  testGoldens('UIText fit altura', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 50
        ..width = 200
        ..fontSize = 100
        ..fit = BoxFit.fitHeight
        ..color = color
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_fit_altura');
  });

  testGoldens('UIText fit altura centralizado', (WidgetTester tester) async {
    await tester.render(
      UIText()
        ..height = 50
        ..width = 200
        ..fontSize = 100
        ..fit = BoxFit.fitHeight
        ..alignment = Alignment.center
        ..color = color
        ..text = 'hello',
    );

    await screenMatchesGolden(tester, 'ui_text_fit_altura_centralizado');
  });
}

extension on WidgetTester {
  Future<void> render(Widget widget) async {
    await loadAppFonts();
    await pumpWidgetBuilder(Center(child: widget));
  }
}
