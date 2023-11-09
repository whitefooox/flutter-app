import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:search3/src/features/recognize/data/datasources/local/ml/i_recognize_service.dart';
import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'isolate_inference.dart';

import 'package:search3/src/core/config/files.dart' as Files;

class TFClassificator implements IRecognizeService {
  static const modelPath = Files.MODEL_PATH;
  static const labelsPath = Files.LABELS_PATH;

  late Interpreter interpreter;
  late List<String> labels;
  late IsolateInference isolateInference;
  late Tensor inputTensor;
  late Tensor outputTensor;

  @override
  Future<void> open() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<void> _loadModel() async {
    interpreter = await Interpreter.fromAsset(modelPath);
    inputTensor = interpreter.getInputTensors().first;
    outputTensor = interpreter.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  Future<void> _loadLabels() async {
    labels = (await rootBundle.loadString(labelsPath)).split('\n');
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

  @override
  int getHeight() {
    return inputTensor.shape[2];
  }

  @override
  int getWidth() {
    return inputTensor.shape[1];
  }
}
