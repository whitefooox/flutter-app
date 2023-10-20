import 'package:search3/src/features/recognize/data/datasources/local/ml/i_recognize_service.dart';
import 'package:search3/src/features/recognize/data/models/recognize.dart';
import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:search3/src/features/recognize/domain/entities/recognize_result.dart';
import 'package:search3/src/features/recognize/domain/repositories/i_recognize_repo.dart';

class RecognizeRepo implements IRecognizeRepo {
  final IRecognizeService _classificator;

  RecognizeRepo(this._classificator);

  @override
  Future<List<RecognizeResult>> recognize(InputImage inputImage) async {
    var reluts = await _classificator.recognize(inputImage);
    return Recognize.fromMap(reluts);
  }

  @override
  Future<void> close() async {
    _classificator.close();
  }

  @override
  Future<void> open() async {
    _classificator.open();
  }
}
