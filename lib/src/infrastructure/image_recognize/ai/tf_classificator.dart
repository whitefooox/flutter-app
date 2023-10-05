import 'dart:isolate';

import 'package:search3/src/application/image_recognize/i_image_classificator.dart';
import 'package:search3/src/application/image_recognize/i_interpreter.dart';
import 'package:search3/src/domain/image_recognize/isolate_inference.dart';
import 'package:search3/src/domain/image_recognize/inference_model.dart';
import 'package:search3/src/domain/image_recognize/input_image.dart';
import 'package:search3/src/domain/image_recognize/recognize_result.dart';
import 'package:search3/src/infrastructure/image_recognize/ai/tf_interpreter.dart';

class TFClassificator implements IImageClassificator {
  late final IInterpreter interpreter;
  late final IsolateInference isolateInference;

  @override
  Future<void> close() async {
    isolateInference.close();
  }

  @override
  Future<void> open() async {
    interpreter = TFInterpreter();
    await interpreter.open();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  @override
  Future<List<RecognizeResult>> recognize(InputImage inputImage) async {
    var isolateModel =
        InferenceModel(inputImage, interpreter.getInterpreterData());
    ReceivePort responsePort = ReceivePort();
    isolateModel.responsePort = responsePort.sendPort;
    isolateInference.sendPort.send(isolateModel);
    List<RecognizeResult> results = await responsePort.first;
    return results;
  }
}
