import 'dart:isolate';
import 'dart:typed_data';
import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateInference {
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(entryPoint, _receivePort.sendPort,
        debugName: _debugName);
    _sendPort = await _receivePort.first;
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

  static Map<String, double> _getClassification(InferenceModel isolateModel) {
    final result = isolateModel.outputBuffer.asUint8List();
    int maxScore = result.reduce((a, b) => a + b);
    var classification = <String, double>{};
    for (var i = 0; i < result.length; i++) {
      if (result[i] != 0) {
        classification[isolateModel.labels[i]] =
            result[i].toDouble() / maxScore.toDouble();
      }
    }
    return classification;
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final InferenceModel isolateModel in port) {
      final input = isolateModel.inputImage.buffer;
      final output = isolateModel.outputBuffer;

      Interpreter interpreter =
          Interpreter.fromAddress(isolateModel.interpreterAddress);
      interpreter.run(input, output);

      isolateModel.responsePort.send(_getClassification(isolateModel));
    }
  }
}

class InferenceModel {
  InputImage inputImage;
  int outputSize;
  int interpreterAddress;
  List<String> labels;
  late SendPort responsePort;
  late ByteBuffer outputBuffer;

  InferenceModel(
      this.inputImage, this.outputSize, this.interpreterAddress, this.labels) {
    outputBuffer = ByteData(outputSize).buffer;
  }
}
