import 'package:injector/injector.dart';
import 'package:search3/src/features/recognize/data/datasources/local/ml/i_recognize_service.dart';
import 'package:search3/src/features/recognize/data/datasources/local/ml/tf_classficator.dart';
import 'package:search3/src/features/recognize/data/repositories/recognize_repo.dart';
import 'package:search3/src/features/recognize/domain/dependencies/i_recognize_repo.dart';
import 'package:search3/src/features/recognize/domain/interactors/recognize_interactor.dart';

final injector = Injector.appInstance;

void injectRecognize() {
  injector.registerDependency<IRecognizeService>(() {
    return TFClassificator();
  });
  injector.registerDependency<RecognizeRepository>(() {
    final recognizeService = injector.get<IRecognizeService>();
    return RecognizeRepo(recognizeService);
  });
  injector.registerDependency<RecognizeInteractor>(() {
    final recognizeRepo = injector.get<RecognizeRepository>();
    return RecognizeInteractor(recognizeRepo);
  });
}
