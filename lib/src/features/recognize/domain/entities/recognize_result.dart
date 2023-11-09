class RecognizeResult {
  final String label;
  final double confidence;

  RecognizeResult({required this.label, required this.confidence});

  double get percent => confidence * 100;
}
