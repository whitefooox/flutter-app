import 'package:injector/injector.dart';
import 'package:search3/src/features/auth/data/firebase_auth_service.dart';
import 'package:search3/src/features/auth/domain/dependencies/i_auth_service.dart';
import 'package:search3/src/features/auth/domain/interactors/auth_interactor.dart';

final injector = Injector.appInstance;

void injectAuth(){
  injector.registerDependency<IAuthService>(() => FirebaseAuthService());
  injector.registerDependency<AuthInteractor>(() => AuthInteractor(injector.get<IAuthService>()));
}