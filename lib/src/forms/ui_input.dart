import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../images/ui_image.dart';
import '../layout/ui_column.dart';
import '../layout/ui_row.dart';
import '../ui_core/ui_core.dart';
import '../ui_core/plug.dart';
import 'ui_text.dart';
import '../super_components/ui_component.dart';

class UInput extends UIComponent with UIState {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController inputController = TextEditingController();
  bool _obscure = true;
  String patternTxt = "[a-zA-Z0-9-._@àáâãéêíóôõúüç '\"]";
  String patternPassword = "[a-zA-Z0-9-._!*àáâãéêíóôõúüç#@!&*()-,:;\$ '\"]";
  String patternFree = "[^ ]";
  String patternEmail = "[a-zA-Z0-9-.-_@]";

  int lengthLimitingText = 255;
  String label = '';
  String hint = '';
  double borderWidth = 1.0;
  bool hidden = false;
  String mask = 'all';

  String _entryKey = '';
  MapEntry get value => MapEntry(_entryKey, inputController.text);
  set value(MapEntry value) {
    _entryKey = value.key;
    inputController.text = value.value;
  }

  Plug<String> onChanged = Plug();

  _toogleObscure() {
    _obscure = !_obscure;
    render();
  }

  Color? _color = Colors.black;
  @override
  set color(Color? value) => _color = value;

  @override
  Widget buildChild(BuildContext context) {
    return Form(
      key: _formKey,
      child:
          UIColumn()
            ..height = pHeight(100)
            ..padding = EdgeInsets.only(top: pHeight(.5))
            ..crossAxisAlignment = CrossAxisAlignment.start
            ..children = [
              Semantics(
                excludeSemantics: true,
                child:
                    UIText()
                      ..height = pHeight(30)
                      ..text = label
                      ..margin = EdgeInsets.only(bottom: pHeight(5))
                      ..alignment = Alignment.centerLeft
                      ..fontWeight = FontWeight.w700
                      ..fontSize = pHeight(25)
                      ..textColor = _color,
              ),
              UIRow()
                ..height = pHeight(64)
                ..width = pWidth(100)
                ..color = Colors.transparent
                ..border = Border.all(
                  width: pHeight(1),
                  color: Color.lerp(_color, Colors.white, 0.5)!,
                )
                ..borderRadius = BorderRadius.circular(pHeight(8))
                ..mainAxisAlignment = MainAxisAlignment.spaceBetween
                ..crossAxisAlignment = CrossAxisAlignment.center
                ..children = [
                  UIComponent()
                    ..height = pHeight(50)
                    ..width = pWidth(hidden ? 83 : 95)
                    ..padding = EdgeInsets.only(left: pWidth(5))
                    ..alignment = Alignment.center
                    ..child = TextField(
                      controller: inputController,
                      smartQuotesType: SmartQuotesType.disabled,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(lengthLimitingText),
                        mask == 'password'
                            ? FilteringTextInputFormatter.allow(
                              RegExp(patternFree),
                            )
                            : mask == 'email'
                            ? FilteringTextInputFormatter.allow(
                              RegExp(patternEmail),
                            )
                            : FilteringTextInputFormatter.allow(
                              RegExp(patternTxt),
                            ),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintText: hint,
                        hintStyle: TextStyle(
                          fontSize: pHeight(22),
                          color: Color.lerp(_color, Colors.white, 0.5)!,
                        ),
                      ),
                      style: TextStyle(fontSize: pHeight(22)),
                      cursorHeight: pHeight(27),
                      cursorColor: _color,
                      obscureText: hidden ? _obscure : false,
                      onChanged: onChanged.send,
                    ),
                  if (hidden)
                    UImage()
                      ..width = pWidth(17)
                      ..height = pHeight(35)
                      ..onTap.then(_toogleObscure)
                      ..src =
                          _obscure
                              ? 'assets/images/andressa/eye.png'
                              : 'assets/images/andressa/eye_closed.png',
                ],
            ],
    );
  }
}
