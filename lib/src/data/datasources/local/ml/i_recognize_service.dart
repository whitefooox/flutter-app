import 'package:search3/src/domain/entities/input_image.dart';

abstract interface class IRecognizeService {
  Future<Map<String, double>> recognize(InputImage inputImage);
}
