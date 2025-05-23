import 'package:flutter/material.dart';

import '../layout/ui_column.dart';
import 'ui_text.dart';
import 'ui_button.dart';
import '../layout/ui_row.dart';
import '../ui_core/plug.dart';
import 'ui_input.dart';

class UIForm extends UIColumn {
  String title = 'Form';
  List<UInput> inputs = [];
  Color? _color = Colors.black;

  @override
  set color(Color? value) => _color = value;

  Plug<Map<String, dynamic>> onSave = Plug();
  Plug onCancel = Plug();

  _saveForm() {
    Map<String, dynamic> formData = {};
    for (final input in inputs) {
      formData[input.value.key] = input.value.value;
    }
    onSave.send(formData);
  }

  _cancel() {
    onCancel.call();
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    crossAxisAlignment = CrossAxisAlignment.center;
    margin = EdgeInsets.all(pHeight(2));
    return [
      UIText()
        ..height = pHeight(5)
        ..width = pWidth(100)
        ..fontSize = pHeight(3)
        ..alignment = Alignment.center
        ..text = title,
      ...inputs.map(
        (input) =>
            input
              ..height = pHeight(8)
              ..width = pWidth(100)
              ..margin = EdgeInsets.only(bottom: pHeight(2))
              ..color = _color,
      ),
      UIRow()
        ..height = pHeight(5)
        ..width = pWidth(100)
        ..margin = EdgeInsets.only(top: pHeight(2))
        ..mainAxisAlignment = MainAxisAlignment.end
        ..children = [
          UIButton()
            ..height = pHeight(5)
            ..width = pWidth(30)
            ..margin = EdgeInsets.only(right: pWidth(2))
            ..alignment = Alignment.centerRight
            ..label = "Cancelar"
            ..color = Colors.grey
            ..onClick.then(_cancel),
          UIButton()
            ..height = pHeight(5)
            ..width = pWidth(20)
            ..alignment = Alignment.centerRight
            ..label = "Salvar"
            ..color = Colors.blue
            ..onClick.then(_saveForm),
        ],
    ];
  }
}
