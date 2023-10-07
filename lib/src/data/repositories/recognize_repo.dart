import 'package:search3/src/data/datasources/local/ml/i_recognize_service.dart';
import 'package:search3/src/data/models/recognize.dart';
import 'package:search3/src/domain/entities/input_image.dart';
import 'package:search3/src/domain/entities/recognize_result.dart';
import 'package:search3/src/domain/repositories/i_recognize_repo.dart';

class RecognizeRepo implements IRecognizeRepo {
  final IRecognizeService _classificator;

  RecognizeRepo(this._classificator);

  @override
  Future<List<RecognizeResult>> recognize(InputImage inputImage) async {
    var reluts = await _classificator.recognize(inputImage);
    return Recognize.fromMap(reluts);
  }
}
