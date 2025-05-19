import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../canvas_component.dart';

class SpriteCut {
  double x;
  double y;
  double width;
  double height;

  SpriteCut(this.x, this.y, this.width, this.height);
}

class CanvasSprite extends CanvasComponent {
  ui.Image? _spriteSheet;
  SpriteCut? cut;
  double baseWidth = 100; // Base width of the flower
  double baseHeight = 100; // Base height of the flower

  set src(String value) {
    SpriteSheets.load(value).then((value) => _spriteSheet = value);
  }

  @override
  void customDraw(Canvas canvas) {
    if (_spriteSheet == null || cut == null) return;

    Paint paint = Paint();
    Rect srcRect = Rect.fromLTWH(cut!.x, cut!.y, cut!.width, cut!.height);

    // Calculate a uniform scale factor based on base size
    double scaleX = pWidth(100) / baseWidth;
    double scaleY = pHeight(100) / baseHeight;
    double scale = min(scaleX, scaleY); // Ensures uniform scaling

    double scaledWidth = cut!.width * scale;
    double scaledHeight = cut!.height * scale;

    canvas.drawImageRect(
      _spriteSheet!,
      srcRect,
      Rect.fromLTWH(0, 0, scaledWidth, scaledHeight),
      paint,
    );
  }
}

class SpriteSheets {
  static final Map<String, ui.Image> _images = {};

  static Future<ui.Image> load(String value) async {
    if (_images.containsKey(value)) {
      return _images[value]!;
    } else {
      final Completer<ui.Image> completer = Completer<ui.Image>();
      final ImageStream stream = AssetImage(
        value,
      ).resolve(ImageConfiguration());

      stream.addListener(
        ImageStreamListener((ImageInfo image, bool synchronousCall) {
          _images[value] = image.image;
          completer.complete(image.image);
        }),
      );
      return completer.future;
    }
  }
}
