import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:search3/src/data/datasources/local/ml/i_recognize_service.dart';
import 'package:search3/src/data/datasources/local/ml/output_list.dart';
import 'package:search3/src/domain/entities/input_image.dart';
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

  // Load model
  Future<void> _loadModel() async {
    final options = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    }

    // Use GPU Delegate
    // doesn't work on emulator
    // if (Platform.isAndroid) {
    //   options.addDelegate(GpuDelegateV2());
    // }

    // Use Metal Delegate
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get tensor input shape [1, 224, 224, 3]
    inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1001]
    outputTensor = interpreter.getOutputTensors().first;

    log('Interpreter loaded successfully');
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  Future<void> initHelper() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<Map<String, double>> _inference(InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort
        .send(inferenceModel..responsePort = responsePort.sendPort);
    // get inference result.
    var results = await responsePort.first;
    //await close();
    return results;
  }

  @override
  Future<Map<String, double>> recognize(InputImage inputImage) async {
    //await initHelper();
    final outputList = OutputList([List<int>.filled(outputTensor.shape[1], 0)]);
    var isolateModel =
        InferenceModel(inputImage, outputList, interpreter.address, labels);
    return _inference(isolateModel);
  }

  Future<void> close() async {
    isolateInference.close();
  }
}
