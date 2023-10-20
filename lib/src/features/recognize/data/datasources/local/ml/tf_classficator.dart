import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:search3/src/features/recognize/data/datasources/local/ml/i_recognize_service.dart';
import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'isolate_inference.dart';

class TFClassificator implements IRecognizeService {
  static const modelPath = 'assets/models/mobilenet_quant.tflite';
  static const labelsPath = 'assets/models/labels.txt';

  late Interpreter interpreter;
  late List<String> labels;
  late IsolateInference isolateInference;
  late Tensor inputTensor;
  late Tensor outputTensor;

  Future<void> _loadModel() async {
    final options = InterpreterOptions();

    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    inputTensor = interpreter.getInputTensors().first;
    outputTensor = interpreter.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  @override
  Future<void> open() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort
        .send(inferenceModel..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  Future<Map<String, double>> recognize(InputImage inputImage) async {
    var isolateModel = InferenceModel(
        inputImage, outputTensor.shape[1], interpreter.address, labels);
    return _inference(isolateModel);
  }

  @override
  Future<void> close() async {
    isolateInference.close();
  }
}
