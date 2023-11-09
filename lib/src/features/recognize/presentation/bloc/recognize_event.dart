part of 'recognize_bloc.dart';

sealed class RecognizeEvent {}

class RecognizeOpenServiceEvent implements RecognizeEvent {}

class RecognizeCloseServiceEvent implements RecognizeEvent {}

class RecognizeImageFromGalleryEvent implements RecognizeEvent {
  final String path;

  RecognizeImageFromGalleryEvent(this.path);
}

class RecognizeImageFromCameraEvent implements RecognizeEvent {
  final CameraImage cameraImage;

  RecognizeImageFromCameraEvent(this.cameraImage);
}
