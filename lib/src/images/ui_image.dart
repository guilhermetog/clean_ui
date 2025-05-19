import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../clean_ui.dart';

enum ImageType { network, asset }

enum ImageExtention {
  png,
  jpg,
  svg,
  gif,
  webp,
  jpeg;

  bool get isSvg => this == ImageExtention.svg;

  bool get isPng => this == ImageExtention.png;

  bool get isJpeg => this == ImageExtention.jpeg;

  bool get isJpg => this == ImageExtention.jpg;

  bool get isWebp => this == ImageExtention.webp;

  bool get isGif => this == ImageExtention.gif;
}

class UImage extends UIComponent with UIState {
  UImageProvider? _src;
  BoxFit _fit = BoxFit.contain;
  Color? svgFill;

  ImageProvider? _imageProvider;
  Size _imageSize = Size.zero;

  /// Set the image source.
  ///
  /// Pass a String or a UImageProvider
  set src(Object? value) {
    if (value is String) {
      _src = UImageProvider(value);
    } else if (value is UImageProvider) {
      _src = value;
    }
  }

  UImage() {
    clipBehavior = Clip.hardEdge;
  }

  @override
  void onInit() {
    _imageProvider = _getImageProvider();
  }

  @override
  void onMount() async {
    if (_imageProvider != null) {
      _imageSize = await _getImageSize(_imageProvider!);
    }
  }

  @override
  Widget buildChild(BuildContext context) {
    _fit = fit != BoxFit.none ? fit : _fit;
    fit = BoxFit.none;
    if (_src == null) return const SizedBox.shrink();
    if (_src!.extention.isSvg) {
      return SizedBox.shrink(); //TODO: implement svg
    } else {
      return _buildFittedImage();
    }
  }

  ImageProvider<Object> _getImageProvider() {
    switch (_src!.type) {
      case ImageType.network:
        return NetworkImage(_src!.src);
      case ImageType.asset:
        return AssetImage(_src!.src);
    }
  }

  Widget _buildFittedImage() {
    if (_fit == BoxFit.cover) {
      return ClipRect(
        child: SizedBox(
          width: pWidth(100),
          height: pHeight(100),
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            alignment: alignment,
            child: Padding(
              padding: EdgeInsets.only(
                top: _src!.top,
                left: _src!.left,
                right: _src!.right,
                bottom: _src!.bottom,
              ),
              child: Image(
                image: _imageProvider!,
                fit: BoxFit.cover,
                width: _imageSize.width,
                height: _imageSize.height,
              ),
            ),
          ),
        ),
      );
    }

    return Image(
      image: _imageProvider!,
      width: pWidth(100),
      height: pHeight(100),
      fit: _fit,
    );
  }

  Future<ui.Image> getImage() async {
    if (_src == null) throw Exception("Source is null");

    // Apenas para imagens rasterizadas (PNG, JPG, WebP, etc.)
    if (_src!.extention.isSvg) {
      throw Exception("SVG format is not supported for getImage.");
    }

    final Completer<ui.Image> completer = Completer();
    final ImageStream stream = _imageProvider!.resolve(
      ImageConfiguration.empty,
    );
    final listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(info.image);
      },
      onError: (dynamic error, StackTrace? stackTrace) {
        completer.completeError(error, stackTrace);
      },
    );

    stream.addListener(listener);
    return completer.future;
  }

  Future<Size> _getImageSize(ImageProvider imageProvider) async {
    final Completer<Size> completer = Completer();

    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      final myImage = info.image;
      final size = Size(myImage.width.toDouble(), myImage.height.toDouble());
      completer.complete(size);
    });

    stream.addListener(listener);
    return completer.future;
  }
}

class UImageProvider {
  final String _src;
  ImageType _type = ImageType.network;
  ImageExtention _extention = ImageExtention.png;
  double top = 0;
  double left = 0;
  double right = 0;
  double bottom = 0;

  String get src => _src;
  ImageType get type => _type;
  ImageExtention get extention => _extention;

  UImageProvider(this._src) {
    _configType();
    _configExtention();
  }

  _configType() {
    if (_src.contains('http')) {
      _type = ImageType.network;
    } else {
      _type = ImageType.asset;
    }
  }

  _configExtention() {
    if (_src.contains('.png')) {
      _extention = ImageExtention.png;
    } else if (_src.contains('.jpg')) {
      _extention = ImageExtention.jpg;
    } else if (_src.contains('.jpeg')) {
      _extention = ImageExtention.jpeg;
    } else if (_src.contains('.gif')) {
      _extention = ImageExtention.gif;
    } else if (_src.contains('.webp')) {
      _extention = ImageExtention.webp;
    }
  }
}
