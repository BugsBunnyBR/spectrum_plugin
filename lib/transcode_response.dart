import 'package:spectrum_plugin/image/image_specfication.dart';

class TranscodeResponse {
  final bool isSuccessful;
  final String ruleName;
  final int totalBytesRead;
  final int totalBytesWritten;
  final ImageSpecification inputImageSpecification;
  final ImageSpecification outputImageSpecification;

  TranscodeResponse({
    this.isSuccessful,
    this.ruleName,
    this.totalBytesRead,
    this.totalBytesWritten,
    this.inputImageSpecification,
    this.outputImageSpecification,
  });

  @override
  String toString() {
    return "TranscodeResponse{" +
        "isSuccessful=" +
        isSuccessful.toString() +
        ", ruleName='" +
        (ruleName ?? "") +
        '\'' +
        ", inputImageSpecification=" +
        inputImageSpecification.toString() +
        ", outputImageSpecification=" +
        outputImageSpecification.toString() +
        ", totalBytesRead=" +
        totalBytesRead.toString() +
        ", totalBytesWritten=" +
        totalBytesWritten.toString() +
        '}';
  }

  static TranscodeResponse parse(Map<String, dynamic> map) {
    return TranscodeResponse(
      isSuccessful: map['isSuccessful'],
      ruleName: map['ruleName'],
      totalBytesRead: map['totalBytesRead'],
      totalBytesWritten: map['totalBytesWritten'],
      inputImageSpecification: ImageSpecification.parse(
        Map<String, dynamic>.from(map['inputImageSpecification'] ?? Map()),
      ),
      outputImageSpecification: ImageSpecification.parse(
        Map<String, dynamic>.from(map['outputImageSpecification'] ?? Map()),
      ),
    );
  }
}
