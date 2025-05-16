import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FittedRects {
  late ui.Image image;
  late Rect place;
  Rect? _imageRect;

  Rect get imageRect => _imageRect ?? Rect.fromLTWH(0, 0, 0, 0);
  set imageRect(Rect rect) => _imageRect ??= rect;

  FittedRects();

  void fit(BoxFit fit) {
    switch (fit) {
      case BoxFit.fill:
        _resolveFill(image, place);
        break;
      case BoxFit.contain:
        _resolveContain(image, place);
        break;
      case BoxFit.cover:
        _resolveCover(image, place);
        break;
      case BoxFit.fitWidth:
        _resolveFitWidth(image, place);
        break;
      case BoxFit.fitHeight:
        _resolveFitHeight(image, place);
        break;
      case BoxFit.scaleDown:
        resolveScaleDown(image, place);
        break;
      case BoxFit.none:
        resolveNone(image, place);
        break;
    }
  }

  _resolveContain(
    ui.Image image,
    Rect outputRect,
  ) {
    final imageSize = Size(
      _imageRect?.width ?? image.width.toDouble(),
      _imageRect?.height ?? image.height.toDouble(),
    );
    final outputSize = outputRect.size;

    final scale =
        (outputSize.width / imageSize.width).clamp(0.0, double.infinity);
    final scaleY =
        (outputSize.height / imageSize.height).clamp(0.0, double.infinity);
    final fitScale = scale < scaleY ? scale : scaleY;

    final fittedSize = Size(
      imageSize.width * fitScale,
      imageSize.height * fitScale,
    );

    final dx = outputRect.left + (outputSize.width - fittedSize.width) / 2;
    final dy = outputRect.top + (outputSize.height - fittedSize.height) / 2;

    this.image = image;
    imageRect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
    place = Rect.fromLTWH(dx, dy, fittedSize.width, fittedSize.height);
  }

  _resolveCover(
    ui.Image image,
    Rect outputRect,
  ) {
    final imageSize = Size(
      _imageRect?.width ?? image.width.toDouble(),
      _imageRect?.height ?? image.height.toDouble(),
    );
    final outputSize = outputRect.size;

    final scale = outputSize.width / imageSize.width;
    final scaleY = outputSize.height / imageSize.height;
    final fitScale = scale > scaleY ? scale : scaleY;

    final fittedWidth = outputSize.width / fitScale;
    final fittedHeight = outputSize.height / fitScale;

    final dx = (imageSize.width - fittedWidth) / 2;
    final dy = (imageSize.height - fittedHeight) / 2;

    this.image = image;
    imageRect = Rect.fromLTWH(dx, dy, fittedWidth, fittedHeight);
    place = outputRect;
  }

  _resolveFill(
    ui.Image image,
    Rect outputRect,
  ) {
    this.image = image;
    imageRect = Rect.fromLTWH(
      0,
      0,
      _imageRect?.width ?? image.width.toDouble(),
      _imageRect?.height ?? image.height.toDouble(),
    );
    place = outputRect;
  }

  _resolveFitWidth(
    ui.Image image,
    Rect outputRect,
  ) {
    final imageWidth = _imageRect?.width ?? image.width.toDouble();
    final imageHeight = _imageRect?.height ?? image.height.toDouble();

    final scale = outputRect.width / imageWidth;
    final height = imageHeight * scale;

    final dy = outputRect.top + (outputRect.height - height) / 2;

    this.image = image;
    imageRect = Rect.fromLTWH(0, 0, imageWidth, imageHeight);
    place = Rect.fromLTWH(outputRect.left, dy, outputRect.width, height);
  }

  _resolveFitHeight(
    ui.Image image,
    Rect outputRect,
  ) {
    final imageWidth = _imageRect?.width ?? image.width.toDouble();
    final imageHeight = _imageRect?.height ?? image.height.toDouble();

    final scale = outputRect.height / imageHeight;
    final width = imageWidth * scale;

    final dx = outputRect.left + (outputRect.width - width) / 2;

    this.image = image;
    imageRect = Rect.fromLTWH(0, 0, imageWidth, imageHeight);
    place = Rect.fromLTWH(dx, outputRect.top, width, outputRect.height);
  }

  resolveNone(
    ui.Image image,
    Rect outputRect,
  ) {
    final imageWidth = _imageRect?.width ?? image.width.toDouble();
    final imageHeight = _imageRect?.height ?? image.height.toDouble();

    final dx = outputRect.left + (outputRect.width - imageWidth) / 2;
    final dy = outputRect.top + (outputRect.height - imageHeight) / 2;

    this.image = image;
    imageRect = Rect.fromLTWH(0, 0, imageWidth, imageHeight);
    place = Rect.fromLTWH(dx, dy, imageWidth, imageHeight);
  }

  resolveScaleDown(
    ui.Image image,
    Rect outputRect,
  ) {
    final full = resolveNone(image, outputRect);
    final contained = _resolveContain(image, outputRect);

    // Only scale down if it overflows
    if (full.place.width > outputRect.width ||
        full.place.height > outputRect.height) {
      return contained;
    } else {
      return full;
    }
  }
}
