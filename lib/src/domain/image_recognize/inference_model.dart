import 'dart:isolate';

import 'package:search3/src/domain/image_recognize/input_image.dart';

class InferenceModel {
  InputImage inputImage;
  late SendPort responsePort;
  dynamic interpreterData;

  InferenceModel(this.inputImage, this.interpreterData);
}
