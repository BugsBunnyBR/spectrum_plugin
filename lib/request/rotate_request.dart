import 'package:flutter/foundation.dart';

class RotateRequest {
  final int degrees;
  final bool flipVertically;
  final bool flipHorizontally;
  final bool forceUpOrientation;

  RotateRequest(
      {@required this.degrees,
      @required this.flipVertically,
      @required this.flipHorizontally,
      @required this.forceUpOrientation});

  Map<String, Object> toMap() {
    final Map<String, Object> map = Map();
    map['degrees'] = degrees;
    map['flipVertically'] = flipVertically;
    map['flipHorizontally'] = flipHorizontally;
    map['forceUpOrientation'] = forceUpOrientation;
    return map;
  }
}
