import 'package:search3/src/domain/entities/input_image.dart';

abstract class IRecognizeService {
  Future<void> open();
  Future<void> close();
  Future<Map<String, double>> recognize(InputImage inputImage);
}
