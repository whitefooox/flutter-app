import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:search3/src/features/recognize/domain/entities/recognize_result.dart';
import 'package:search3/src/features/recognize/domain/services/recognize_image_use_case.dart';
import 'package:search3/src/features/recognize/presentation/presenter/input_image_presenter.dart';

part 'recognize_event.dart';
part 'recognize_state.dart';

class RecognizeBloc extends Bloc<RecognizeEvent, RecognizeState> {
  final _recognizeService = Injector.appInstance.get<RecognizeService>();

  RecognizeBloc() : super(RecognizeState()) {
    on<RecognizeOpenServiceEvent>(_openService);
    on<RecognizeCloseServiceEvent>(_closeService);
    on<RecognizeImageFromGalleryEvent>(_fromGallery);
    on<RecognizeImageFromCameraEvent>(_fromCamera);
  }

  Future<void> _openService(
      RecognizeOpenServiceEvent event, Emitter<RecognizeState> emit) async {
    if (state.isStarted) return;
    await _recognizeService.open();
    emit(state.copyWith(isStarted: true));
  }

  Future<void> _closeService(
      RecognizeCloseServiceEvent event, Emitter<RecognizeState> emit) async {
    if (!state.isStarted) return;
    await _recognizeService.close();
    emit(state.copyWith(isStarted: false));
  }

  Future<void> _fromGallery(RecognizeImageFromGalleryEvent event,
      Emitter<RecognizeState> emit) async {
    if (!state.isStarted) return;
    emit(state.copyWith(isProcessing: true, state: "process"));
    int width = _recognizeService.getWidth();
    int height = _recognizeService.getHeight();
    final image = InputImagePresenter.getImageFromPath(event.path);
    final inputImage = InputImagePresenter.prepareImage(image, width, height);
    final results = await _recognizeService.recognize(inputImage);
    emit(
        state.copyWith(isProcessing: false, results: results, state: "result"));
  }

  Future<void> _fromCamera(
      RecognizeImageFromCameraEvent event, Emitter<RecognizeState> emit) async {
    if (!state.isStarted) return;
    emit(state.copyWith(isProcessing: true, state: "process"));
    int width = _recognizeService.getWidth();
    int height = _recognizeService.getHeight();
    final image =
        InputImagePresenter.getImageFromCameraImage(event.cameraImage);
    final inputImage = InputImagePresenter.prepareImage(image, width, height);
    final results = await _recognizeService.recognize(inputImage);
    emit(
        state.copyWith(isProcessing: false, results: results, state: "result"));
  }
}
