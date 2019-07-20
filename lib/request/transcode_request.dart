import 'package:flutter/foundation.dart';
import 'package:spectrum_plugin/image/encoded_image_format.dart';
import 'package:spectrum_plugin/request/crop_request.dart';
import 'package:spectrum_plugin/request/resize_request.dart';
import 'package:spectrum_plugin/request/rotate_request.dart';


enum EncodeRequirementMode { LOSSLESS, LOSSY, ANY }

class TranscodeRequest {
  final String source;
  final String sink;
  final String callerContext;
  final EncodedImageFormat format;
  final EncodeRequirementMode mode;
  final int quality;
  final ResizeRequest resize;
  final CropRequest crop;
  final RotateRequest rotate;

  TranscodeRequest({
    @required this.source,
    @required this.sink,
    @required this.callerContext,
    @required this.format,
    @required this.mode,
    @required this.quality,
    this.resize,
    this.crop,
    this.rotate,
  });

  Map<String, Object> toMap() {
    final Map<String, Object> map = Map();
    map['source'] = source;
    map['sink'] = sink;
    map['callerContext'] = callerContext;
    map['format'] = describeEnum(format);
    map['mode'] = describeEnum(mode);
    map['quality'] = quality;

    map['resize'] = resize?.toMap() ?? Map<String, Object>();
    map['crop'] = crop?.toMap() ?? Map<String, Object>();
    map['rotate'] = rotate?.toMap() ?? Map<String, Object>();
    return map;
  }
}
