import 'dart:async';

import 'package:flutter/services.dart';
import 'package:spectrum_plugin/request/transcode_request.dart';
import 'package:spectrum_plugin/transcode_response.dart';

const MethodChannel _channel =
    const MethodChannel('br.com.bugs.bunny.plugin.spectrum');

class SpectrumPlugin {
  static Future<TranscodeResponse> transcode(TranscodeRequest tr) async {
    final map = Map<String, dynamic>.from(
        await _channel.invokeMethod('transcode', tr.toMap()));
    return TranscodeResponse.parse(map);
  }
}
