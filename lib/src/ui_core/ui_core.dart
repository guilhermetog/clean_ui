import 'package:flutter/material.dart';

import 'key_manager.dart';
import 'plug.dart';
import 'ui_animation.dart';

enum UILifecycleState {
  none,
  inited,
  mounted,
  unmonted;

  bool get isMounted => this == mounted;
  bool get isInited => this == inited;
  bool get isUnmonted => this == unmonted;
}

/// Core

abstract class UICore extends StatelessWidget {
  late Widget _widget;
  final String? _name;

  UICore([this._name]) {
    if (this is UIState) {
      (this as UIState).config();
    }
  }

  Widget buildLayout(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildLayout(context);
  }
}

///
///
///
///
///
///
///
///
///
///
///  UI STATE

mixin UIState on UICore {
  final Plug _onUpdate = Plug();
  UILifecycleState lifecycle = UILifecycleState.none;

  void config() {
    _widget = UICoreStateful(_name, this);
  }

  void onInit() {}
  void onMount() {}
  void dispose() {}

  void render() {
    if (_onUpdate.isConnected) {
      _onUpdate.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _widget;
  }
}

class UICoreStateful extends StatefulWidget {
  final String? _name;
  final UIState state;

  UICoreStateful(this._name, this.state)
    : super(key: KeyManager.getKey(_name) ?? GlobalKey());

  @override
  State<UICoreStateful> createState() => _UICoreStatefulState();
}

class _UICoreStatefulState extends State<UICoreStateful> {
  @override
  void initState() {
    widget.state.lifecycle = UILifecycleState.inited;
    super.initState();
    widget.state._onUpdate.then(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.state.lifecycle = UILifecycleState.mounted;
      widget.state.onMount();
    });
    widget.state.onInit();
  }

  @override
  void dispose() {
    widget.state.lifecycle = UILifecycleState.unmonted;
    KeyManager.removeKey(widget._name);
    widget.state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.state.buildLayout(context);
  }
}

///
///
///
///
///
///
///
///
///
///
///UI Animated

mixin UIAnimated on UIState {
  late UIAnimation animation;

  @override
  void config() {
    _widget = UICoreAnimated(_name, this);
  }

  void buildAnimation(UIAnimation animation) {
    this.animation = animation;
  }
}

class UICoreAnimated extends UICoreStateful {
  UICoreAnimated(super._name, UIAnimated super.state);

  @override
  State<UICoreStateful> createState() => _UICoreAnimatedState();
}

class _UICoreAnimatedState extends _UICoreStatefulState
    with TickerProviderStateMixin {
  UIAnimation? _uiAnimation;

  @override
  void initState() {
    super.initState();
    _uiAnimation = UIAnimation(this);
    (widget.state as UIAnimated).buildAnimation(_uiAnimation!);
  }

  @override
  void dispose() {
    _uiAnimation?.dispose();
    super.dispose();
  }
}

//
//
//
//
//
//
//
//
//
//
//
//
//
//
// UIRouteMonitor
final RouteObserver<ModalRoute> uiRouteMonitor = RouteObserver<ModalRoute>();

class UIRouteObserver extends RouteObserver<ModalRoute> {
  static final UIRouteObserver _instance = UIRouteObserver._();
  UIRouteObserver._();
  factory UIRouteObserver() => _instance;
}

mixin UIRouteMonitor on UIState {
  void onPopNext() {}
  void onPushNext() {}

  @override
  void config() {
    super.config();
    _widget = UICoreStatefulRoute(_name, this);
  }
}

class UICoreStatefulRoute extends UICoreStateful {
  UICoreStatefulRoute(super._name, super.state);

  @override
  State<UICoreStateful> createState() => _UICoreStatefulRouteState();
}

class _UICoreStatefulRouteState extends _UICoreStatefulState with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    UIRouteObserver().subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    UIRouteObserver().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (widget.state is UIRouteMonitor) {
      (widget.state as UIRouteMonitor).onPopNext();
    }
  }

  @override
  void didPushNext() {
    if (widget.state is UIRouteMonitor) {
      (widget.state as UIRouteMonitor).onPushNext();
    }
  }
}
