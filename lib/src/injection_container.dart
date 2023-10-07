import 'package:injector/injector.dart';
import 'package:search3/src/data/datasources/local/ml/i_recognize_service.dart';
import 'package:search3/src/data/datasources/local/ml/tf_classficator.dart';
import 'package:search3/src/data/repositories/recognize_repo.dart';
import 'package:search3/src/domain/repositories/i_recognize_repo.dart';
import 'package:search3/src/domain/usecases/recognize_image_use_case.dart';

class InjectorContainer {
  final injector = Injector.appInstance;

  InjectorContainer() {
    injector.registerDependency<IRecognizeService>(() {
      return TFClassificator();
    });
    injector.registerDependency<IRecognizeRepo>(() {
      final recognizeService = injector.get<IRecognizeService>();
      return RecognizeRepo(recognizeService);
    });
    injector.registerDependency<RecognizeImageUseCase>(() {
      final recognizeRepo = injector.get<IRecognizeRepo>();
      return RecognizeImageUseCase(recognizeRepo);
    });
  }
}
