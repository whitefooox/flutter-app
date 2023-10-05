import 'package:search3/src/domain/image_recognize/input_image.dart';
import 'package:search3/src/domain/image_recognize/recognize_result.dart';

abstract class IImageClassificator {
  Future<void> open();
  Future<void> close();
  Future<List<RecognizeResult>> recognize(InputImage inputImage);
}
