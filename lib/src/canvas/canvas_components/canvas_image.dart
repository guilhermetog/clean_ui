import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../_tools/fitted_rects.dart';
import '../canvas_component.dart';
import '../controls/canvas_mouse_control.dart';

class CanvasImage extends CanvasComponent with CanvasMouseControl {
  ui.Image? _image;
  double imageTop = 0;
  double imageLeft = 0;
  double? imageWidth;
  double? imageHeight;

  set src(String value) {
    load(value).then((image) {
      _image = image;
      imageWidth ??= image.width.toDouble();
      imageHeight ??= image.height.toDouble();
      render();
    });
  }

  CanvasImage() {
    unrender();
  }

  goToFrame(int value) {
    if (imageWidth != null) {
      imageLeft = value * imageWidth!;
    }
  }

  @override
  void customDraw(Canvas canvas) {
    FittedRects rect =
        FittedRects()
          ..image = _image!
          ..imageRect = Rect.fromLTWH(
            imageLeft,
            imageTop,
            imageWidth!,
            imageHeight!,
          )
          ..place = Rect.fromLTWH(0, 0, pWidth(100), pHeight(100))
          ..fit(fit);

    if (color != null && color != Colors.transparent) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, pWidth(100), pHeight(100)),
        Paint()..color = color!,
      );
    }

    canvas.drawImageRect(rect.image, rect.imageRect, rect.place, Paint());
  }

  static Future<ui.Image> load(String value) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();

    ImageStream stream;

    // Verifica se o caminho da imagem começa com "http"
    if (value.startsWith('http')) {
      // Carrega a imagem da web usando NetworkImage
      stream = NetworkImage(value).resolve(ImageConfiguration());
    } else {
      // Caso contrário, carrega a imagem do asset
      stream = AssetImage(value).resolve(ImageConfiguration());
    }

    stream.addListener(
      ImageStreamListener((ImageInfo image, bool synchronousCall) {
        completer.complete(image.image);
      }),
    );

    return completer.future;
  }
}
