part of 'recognize_bloc.dart';

class RecognizeState {
  final bool isStarted;
  final bool isProcessing;
  final String state;
  final List<RecognizeResult> results;

  RecognizeState(
      {this.isStarted = false,
      this.isProcessing = false,
      this.results = const [],
      this.state = ""});

  RecognizeState copyWith(
      {bool? isStarted,
      bool? isProcessing,
      List<RecognizeResult>? results,
      String? state}) {
    return RecognizeState(
        isStarted: isStarted ?? this.isStarted,
        isProcessing: isProcessing ?? this.isProcessing,
        results: results ?? this.results,
        state: state ?? this.state);
  }

  void printLog() {
    print("isStarted: $isStarted");
    print("isProcessing: $isProcessing");
    print("state: $state");
  }
}
