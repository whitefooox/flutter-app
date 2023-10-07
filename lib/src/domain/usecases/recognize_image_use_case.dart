import 'package:search3/src/domain/entities/input_image.dart';
import 'package:search3/src/domain/entities/recognize_result.dart';
import 'package:search3/src/domain/repositories/i_recognize_repo.dart';

class RecognizeImageUseCase {
  final IRecognizeRepo recognizeRepo;

  RecognizeImageUseCase(this.recognizeRepo);

  Future<List<RecognizeResult>> call(InputImage inputImage) {
    return recognizeRepo.recognize(inputImage);
  }
}
