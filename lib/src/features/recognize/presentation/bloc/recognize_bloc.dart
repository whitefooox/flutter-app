import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:search3/src/features/recognize/domain/entities/input_image.dart';
import 'package:search3/src/features/recognize/domain/entities/recognize_result.dart';
import 'package:search3/src/features/recognize/domain/usecases/recognize_image_use_case.dart';

part 'recognize_event.dart';
part 'recognize_state.dart';

class RecognizeBloc extends Bloc<RecognizeEvent, RecognizeState> {
  final _recognizeService = Injector.appInstance.get<RecognizeImageUseCase>();

  RecognizeBloc() : super(RecognizeState()) {
    on<RecognizeOpenServiceEvent>(_openService);
    on<RecognizeCloseServiceEvent>(_closeService);
    on<RecognizeRunServiceEvent>(_runService);
  }

  _openService(
      RecognizeOpenServiceEvent event, Emitter<RecognizeState> emit) async {
    if (state.isStarted) return;
    await _recognizeService.open();
    emit(state.copyWith(isStarted: true));
  }

  _closeService(
      RecognizeCloseServiceEvent event, Emitter<RecognizeState> emit) async {
    if (!state.isStarted) return;
    await _recognizeService.close();
    emit(state.copyWith(isStarted: false));
  }

  _runService(
      RecognizeRunServiceEvent event, Emitter<RecognizeState> emit) async {
    if (!state.isStarted) return;
    emit(state.copyWith(isProcessing: true, state: "process", results: []));
    await Future.delayed(Duration(seconds: 3));
    List<RecognizeResult> results =
        await _recognizeService.recognize(event.inputImage);
    emit(
        state.copyWith(isProcessing: false, results: results, state: "result"));
  }
}
