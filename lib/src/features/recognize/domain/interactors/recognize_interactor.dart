import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:search3/src/features/recognize/domain/entities/recognize_result.dart';
import 'package:search3/src/features/recognize/domain/dependencies/i_recognize_repo.dart';

class RecognizeInteractor {
  final RecognizeRepository _recognizeRepository;

  RecognizeInteractor(this._recognizeRepository);

  Future<List<RecognizeResult>> recognize(InputImage inputImage) {
    return _recognizeRepository.recognize(inputImage);
  }

  Future<void> open() async {
    _recognizeRepository.open();
  }

  Future<void> close() async {
    _recognizeRepository.close();
  }

  int getWidth() {
    return _recognizeRepository.getWidth();
  }

  int getHeight() {
    return _recognizeRepository.getHeight();
  }
}
