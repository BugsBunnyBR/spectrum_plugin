import 'package:flutter/foundation.dart';

enum ResizeRequirementMode { EXACT, EXACT_OR_SMALLER, EXACT_OR_LARGER }

class ResizeRequest {
  final ResizeRequirementMode mode;
  final int width;
  final int height;

  ResizeRequest({
    @required this.mode,
    @required this.width,
    @required this.height,
  });

  Map<String, Object> toMap() {
    final Map<String, Object> map = Map();
    map['mode'] = describeEnum(mode);
    map['height'] = height;
    map['width'] = width;
    return map;
  }
}
