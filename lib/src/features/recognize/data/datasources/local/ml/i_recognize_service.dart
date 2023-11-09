import 'package:search3/src/features/recognize/domain/entities/input_image.dart';

abstract class IRecognizeService {
  Future<void> open();
  Future<void> close();
  int getWidth();
  int getHeight();
  Future<Map<String, double>> recognize(InputImage inputImage);
}
