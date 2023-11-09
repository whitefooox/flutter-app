import 'package:search3/src/features/recognize/domain/entities/recognize_result.dart';

class Recognize {
  static List<RecognizeResult> fromMap(Map<String, double> map) {
    List<RecognizeResult> recognizedObjects = map.entries.map((entry) {
      return RecognizeResult(label: entry.key, confidence: entry.value);
    }).toList();
    recognizedObjects.sort((a, b) => b.confidence.compareTo(a.confidence));
    return recognizedObjects;
  }
}
