part of 'recognize_bloc.dart';

sealed class RecognizeEvent {}

class RecognizeOpenServiceEvent implements RecognizeEvent {}

class RecognizeCloseServiceEvent implements RecognizeEvent {}

class RecognizeRunServiceEvent implements RecognizeEvent {
  final InputImage inputImage;

  RecognizeRunServiceEvent(this.inputImage);
}
