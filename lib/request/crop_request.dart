import 'package:flutter/foundation.dart';

class CropRequest {
  final double left;
  final double top;
  final double right;
  final double bottom;
  final bool mustBeExact;

  CropRequest({
    @required this.left,
    @required this.top,
    @required this.right,
    @required this.bottom,
    @required this.mustBeExact,
  });

  Map<String, Object> toMap() {
    final Map<String, Object> map = Map();
    map['left'] = left;
    map['top'] = top;
    map['right'] = right;
    map['bottom'] = bottom;
    map['mustBeExact'] = mustBeExact;
    return map;
  }
}
