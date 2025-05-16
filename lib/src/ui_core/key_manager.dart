import 'package:flutter/material.dart';

class KeyManager {
  static final Map<String, GlobalKey> _keys = {};

  static GlobalKey? getKey(String? keyName) {
    if (keyName == null) return null;
    if (!_keys.containsKey(keyName)) {
      _keys[keyName] = GlobalKey();
    }
    return _keys[keyName]!;
  }

  static void removeKey(String? keyName) {
    if (keyName == null) return;
    _keys.remove(keyName);
  }
}
