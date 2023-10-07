import 'package:search3/src/domain/entities/recognize_result.dart';

class Recognize {
  static List<RecognizeResult> fromMap(Map<String, double> map) {
    List<RecognizeResult> recognizedObjects = map.entries.map((entry) {
      return RecognizeResult(entry.key, entry.value);
    }).toList();
    recognizedObjects.sort((a, b) => b.probability.compareTo(a.probability));
    return recognizedObjects;
  }
}
