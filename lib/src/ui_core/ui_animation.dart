import 'dart:async';
import 'package:flutter/material.dart';
import 'plug.dart';

enum UIAnimationStatus {
  forward,
  forwardComplete,
  pausedForward,
  reverse,
  reverseComplete,
  pausedReverse,
  idle;
}

class UIAnimationData {
  Duration _waitAfter = Duration.zero;
  bool _stopWhenFinish = false;
  final AnimationController controller;
  UIAnimationStatus status = UIAnimationStatus.idle;
  AnimationRange range;
  Completer? _completer;
  bool repeat = false;
  bool _disposed = false;

  final Plug<UIAnimationData> onProgress = Plug();
  final Plug onUpdate = Plug();

  Duration get duration => controller.duration ?? Duration.zero;
  double get progress => range.realProgress(controller.value);
  double get _workProgress => controller.value;

  UIAnimationData(this.controller, this.range) {
    controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() async {
    final completer = _completer;

    if (completer != null && !completer.isCompleted) {
      if (_workProgress >= controller.upperBound &&
          status == UIAnimationStatus.forward) {
        status = UIAnimationStatus.forwardComplete;
        if (repeat) {
          pause();
          await Future.delayed(_waitAfter);
          play();
        } else {
          if (_stopWhenFinish) {
            stop();
          } else {
            pause();
          }
          completer.complete();
        }
      } else if (_workProgress <= controller.lowerBound &&
          status == UIAnimationStatus.reverse) {
        status = UIAnimationStatus.reverseComplete;
        if (repeat) {
          pause();
          await Future.delayed(_waitAfter);
          reverse();
        } else {
          if (_stopWhenFinish) {
            stop();
          } else {
            pause();
          }
          completer.complete();
        }
      }
    }

    if (onProgress.isConnected) {
      onProgress.send(this);
    }
  }

  Future<void> pause() async {
    final data = this;
    data.controller.stop();
    data.status = data.status == UIAnimationStatus.forward
        ? UIAnimationStatus.pausedForward
        : UIAnimationStatus.pausedReverse;
  }

  Future<void> stop() async {
    status = UIAnimationStatus.idle;
    controller.reset();
    controller.stop();
    await Future.delayed(Duration.zero);
  }

  Future<void> play() async {
    if (_disposed) return;
    controller.reset();
    _completer = Completer<void>();
    status = UIAnimationStatus.forward;
    await controller.forward();
    return _completer!.future;
  }

  Future<void> resume() async {
    final data = this;
    if (data.status != UIAnimationStatus.forward &&
        data.status != UIAnimationStatus.forwardComplete) {
      _completer = Completer<void>();
      data.status = UIAnimationStatus.forward;
      await data.controller.forward();
      return _completer!.future;
    }
  }

  Future<void> playReverse() async {
    final data = this;
    data.controller.reset();
    data.controller.value = 1;
    _completer = Completer<void>();
    data.status = UIAnimationStatus.reverse;
    await data.controller.reverse();
    return _completer!.future;
  }

  Future<void> reverse() async {
    final data = this;
    if (data.status != UIAnimationStatus.reverse &&
        data.status != UIAnimationStatus.reverseComplete) {
      _completer = Completer<void>();
      data.status = UIAnimationStatus.reverse;
      await data.controller.reverse();
      return _completer!.future;
    }
  }

  void jumpTo(double value) {
    controller.value = value;
  }

  dispose() {
    _disposed = true;
    controller.removeListener(_onControllerUpdate);
    controller.dispose();
  }
}

class AnimationRange {
  double realStart;
  double realEnd;

  AnimationRange(this.realStart, this.realEnd);

  double realProgress(double progress) =>
      ((realEnd - realStart) * progress) + realStart;
}

class UIAnimation {
  final TickerProvider vsync;
  final Map<String, UIAnimationData> _animations = {};

  UIAnimation(this.vsync);

  void create({
    required String name,
    required Duration duration,
    Duration waitAfter = Duration.zero,
    double start = 0,
    double end = 1,
    bool repeat = false,
    bool stopWhenFinish = false,
    Function(UIAnimationData)? onProgress,
  }) {
    final controller = AnimationController(
      vsync: vsync,
      duration: duration,
      lowerBound: 0,
      upperBound: 1,
    );

    _animations[name] = UIAnimationData(controller, AnimationRange(start, end))
      ..repeat = repeat
      .._waitAfter = waitAfter
      .._stopWhenFinish = stopWhenFinish;

    if (onProgress != null) {
      _animations[name]!.onProgress.take(onProgress);
    }
  }

  Future<void> pause(String name) async {
    if (!_animations.containsKey(name)) return;
    return _animations[name]!.pause();
  }

  Future<void> stop(String name) async {
    if (!_animations.containsKey(name)) return;
    return _animations[name]!.stop();
  }

  Future<void> play(String name) async {
    if (!_animations.containsKey(name)) return;
    return _animations[name]!.play();
  }

  Future<void> playReverse(String name) async {
    if (!_animations.containsKey(name)) return;
    return _animations[name]!.playReverse();
  }

  Future<void> resume(String name) async {
    if (!_animations.containsKey(name)) return;
    return _animations[name]!.resume();
  }

  Future<void> reverse(String name) async {
    if (!_animations.containsKey(name)) return;
    return _animations[name]!.reverse();
  }

  AnimationController? getController(String name) {
    return _animations[name]?.controller;
  }

  void dispose() {
    _animations.forEach((key, value) {
      value.dispose();
    });
    _animations.clear();
  }
}
