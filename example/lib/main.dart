import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spectrum_plugin/image/encoded_image_format.dart';
import 'package:spectrum_plugin/request/crop_request.dart';
import 'package:spectrum_plugin/request/resize_request.dart';
import 'package:spectrum_plugin/request/rotate_request.dart';
import 'package:spectrum_plugin/spectrum_plugin.dart';
import 'package:spectrum_plugin/request/transcode_request.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '';
  File _source;
  File _sink;

  Future<void> transcode(ImageSource imgSource) async {
    File source = await ImagePicker.pickImage(source: imgSource);
    if (source == null) {
      // User cancelled the pic.
      return;
    }
    String result = '';
    final sourceName = source.path.split('/').last;
    final tempDir = await getTemporaryDirectory();
    File sink = File(tempDir.path + '/' + sourceName);
    final size = MediaQuery.of(context).size;

    final tr = TranscodeRequest(
      source: source.path,
      sink: sink.path,
      callerContext: "WTF",
      quality: 100,
      format: EncodedImageFormat.JPEG,
      mode: EncodeRequirementMode.ANY,
      crop: CropRequest(
        top: 0.05,
        left: 0.05,
        bottom: 0.95,
        right: 0.95,
        mustBeExact: false,
      ),
      resize: ResizeRequest(
          mode: ResizeRequirementMode.EXACT_OR_SMALLER,
          height: size.height.floor(),
          width: size.width.floor()),
      rotate: RotateRequest(
        degrees: 0,
        flipHorizontally: false,
        flipVertically: false,
        forceUpOrientation: false,
      ),
    );
    final response = await SpectrumPlugin.transcode(tr);
    result = response.toString();

    if (!mounted) return;

    setState(() {
      _result = result;
      _source = source;
      _sink = sink;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {
                      await transcode(ImageSource.camera);
                    },
                    child: Text('From Camera'),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await transcode(ImageSource.gallery);
                    },
                    child: Text('From Gallery'),
                  ),
                ],
              ),
              if (_source != null) Image.file(_source) else Container(),
              if (_sink != null) Image.file(_sink) else Container(),
              Center(
                child: Text('$_result\n'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
