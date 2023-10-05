import 'package:search3/src/domain/image_recognize/input_image.dart';
import 'package:search3/src/domain/image_recognize/recognize_result.dart';

abstract class IInterpreter {
  Future<void> open();
  Future<void> close();
  List<RecognizeResult> run(InputImage inputImage);
  dynamic getInterpreterData();
}
