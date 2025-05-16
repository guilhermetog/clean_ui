import 'package:flutter/material.dart';
import '../super_components/ui_component.dart';
import '../super_components/ui_layout.dart';

/// Exemplo de Uso
/// ```dart
///   DateTime selected = DateTime.now();
///   ...
///   openDate() {
///     DatePicker()
///        ..selected = selected
///       ..onClose.take((result) {
///         selected = result;
///       })
///       ..open(context);
///   }
/// ```
///

class UIDatePicker extends UIComponent with UIOverlay {
  DateTime selected = DateTime.now();
  @override
  Widget buildChild(BuildContext context) {
    return DatePickerDialog(
        initialDate: selected,
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now());
  }
}
