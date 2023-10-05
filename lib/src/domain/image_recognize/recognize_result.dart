class RecognizeResult {
  final String name;
  final double probability;

  RecognizeResult(this.name, this.probability);

  double getPercent() {
    return double.parse((probability * 100).toStringAsFixed(2));
  }
}
