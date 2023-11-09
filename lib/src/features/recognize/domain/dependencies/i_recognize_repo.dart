import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:search3/src/features/recognize/domain/entities/recognize_result.dart';

abstract interface class RecognizeRepository {
  Future<void> open();
  Future<void> close();
  int getWidth();
  int getHeight();
  Future<List<RecognizeResult>> recognize(InputImage inputImage);
}
