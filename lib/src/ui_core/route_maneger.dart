import 'ui_core.dart';

class RouteManager {
  static final Map<String, UICore> _cores = {};

  T register<T extends UICore>(T core) {
    if (_cores.containsKey((core).toString())) {
      return _cores[(core).toString()] as T;
    } else {
      _cores[(core).toString()] = core;
      return core;
    }
  }

  void remove<T extends UICore>(T core) {
    _cores.removeWhere((key, value) => key == (core).toString());
  }
}
