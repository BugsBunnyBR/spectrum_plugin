import 'package:flutter/foundation.dart';
import 'package:spectrum_plugin/image/encoded_image_format.dart';
import 'package:spectrum_plugin/image/image_chroma_sampling_mode.dart';
import 'package:spectrum_plugin/image/image_orientation.dart';
import 'package:spectrum_plugin/image/image_size.dart';
import 'package:spectrum_plugin/pixel_specification.dart';

class ImageSpecification {
  final ImageChromaSamplingMode chromaSamplingMode;
  final EncodedImageFormat format;
  final ImageOrientation orientation;
  final Map<String, dynamic> metadata;
  final ImageSize size;
  final PixelSpecification pixelSpecification;

  ImageSpecification({
    this.chromaSamplingMode,
    this.format,
    this.orientation,
    this.metadata,
    this.size,
    this.pixelSpecification,
  });

  @override
  String toString() {
    return "ImageSpecification{" +
        "size=" +
        size.toString() +
        ", format=" +
        format.toString() +
        ", pixelSpecification=" +
        pixelSpecification.toString() +
        ", orientation=" +
        orientation.toString() +
        ", chromaSamplingMode=" +
        chromaSamplingMode.toString() +
        ", metadata=" +
        (metadata.toString() ?? "") +
        '}';
  }

  static ImageSpecification parse(Map<String, dynamic> map) {
    return ImageSpecification(
      metadata: Map<String, dynamic>.from(map['metadata'] ?? Map()),
      size: ImageSize.parse(
        Map<String, dynamic>.from(map['size'] ?? Map()),
      ),
      pixelSpecification: PixelSpecification.values.firstWhere(
        (value) => map['pixelSpecification'] == describeEnum(value),
        orElse: () => null,
      ),
      chromaSamplingMode: ImageChromaSamplingMode.values.firstWhere(
        (value) => map['chromaSamplingMode'] == describeEnum(value),
        orElse: () => null,
      ),
      format: EncodedImageFormat.values.firstWhere(
        (value) => map['format'] == describeEnum(value),
        orElse: () => null,
      ),
      orientation: ImageOrientation.values.firstWhere(
        (value) => map['orientation'] == describeEnum(value),
        orElse: () => null,
      ),
    );
  }
}
