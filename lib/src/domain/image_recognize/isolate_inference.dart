import 'dart:isolate';

import 'package:search3/src/domain/image_recognize/inference_model.dart';

class IsolateInference {
  static const String _debugName = "ISOLATE_INFERENCE";
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

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final InferenceModel isolateModel in port) {
      final interpreter = isolateModel.interpreterData.getInterpreter();
      final inputImage = isolateModel.inputImage;
      final results = interpreter.run(inputImage);
      isolateModel.responsePort.send(results);
    }
  }
}
