import 'package:flutter/foundation.dart';

class ImageSize {
  final int height;
  final int width;

  ImageSize({
    @required this.height,
  @required this.width,
  });

  @override
  String toString() {
    return "ImageSize{" +
        "width=" +
        width.toString() +
        ", height=" +
        height.toString() +
        '}';
  }

  static ImageSize parse(Map<String, dynamic> map) {
    return ImageSize(
      height: map['height'],
      width: map['width'],
    );
  }
}
