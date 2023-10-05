import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:search3/src/application/image_recognize/i_interpreter.dart';
import 'package:search3/src/domain/image_recognize/input_image.dart';
import 'package:search3/src/domain/image_recognize/recognize_result.dart';
import 'package:search3/src/infrastructure/image_recognize/ai/image_utils.dart';
import 'package:search3/src/infrastructure/image_recognize/ai/interpreter_data.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as image_lib;

class TFInterpreter implements IInterpreter {
  static const modelPath = 'assets/models/mobilenet_quant.tflite';
  static const labelsPath = 'assets/models/labels.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late Tensor inputTensor;
  late Tensor outputTensor;
  late List<int> inputShape;
  late List<int> outputShape;

  TFInterpreter();

  TFInterpreter.fromIntrepterData(InterpreterData data) {
    interpreter = Interpreter.fromAddress(data.interpreterAddress);
    labels = data.labels;
    inputShape = data.inputShape;
    outputShape = data.outputShape;
  }

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
    inputShape = inputTensor.shape;
    outputShape = outputTensor.shape;
    log('Interpreter loaded successfully');
  }

  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
  }

  @override
  List<RecognizeResult> run(InputImage inputImage) {
    image_lib.Image? img;
    if (inputImage.isCameraFrame) {
      img = ImageUtils.convertCameraImage(inputImage.data!);
    } else {
      img = inputImage.data;
    }

    image_lib.Image imageInput = image_lib.copyResize(
      img!,
      width: inputShape[1],
      height: inputShape[2],
    );

    if (Platform.isAndroid && inputImage.isCameraFrame) {
      imageInput = image_lib.copyRotate(imageInput, angle: 90);
    }

    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [pixel.r, pixel.g, pixel.b];
        },
      ),
    );
    final input = [imageMatrix];
    final output = [List<int>.filled(outputShape[1], 0)];
    interpreter.run(input, output);
    final result = output.first;
    int maxScore = result.reduce((a, b) => a + b);

    var classification = <String, double>{};
    for (var i = 0; i < result.length; i++) {
      if (result[i] != 0) {
        classification[labels[i]] = result[i].toDouble() / maxScore.toDouble();
      }
    }
    List<RecognizeResult> recognizedObjects =
        classification.entries.map((entry) {
      return RecognizeResult(entry.key, entry.value);
    }).toList();
    recognizedObjects.sort((a, b) => b.probability.compareTo(a.probability));
    return recognizedObjects;
  }

  @override
  Future<void> close() async {
    //
  }

  @override
  Future<void> open() async {
    _loadLabels();
    _loadModel();
  }

  @override
  dynamic getInterpreterData() {
    return InterpreterData(
        interpreter.address, labels, inputTensor.shape, outputTensor.shape);
  }

  static TFInterpreter fromAddress(InterpreterData data) {
    return TFInterpreter.fromIntrepterData(data);
  }
}
