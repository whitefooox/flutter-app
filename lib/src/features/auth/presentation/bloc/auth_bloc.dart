import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injector/injector.dart';
import 'package:search3/src/features/auth/domain/exceptions/auth_exception.dart';
import 'package:search3/src/features/auth/domain/interactors/auth_interactor.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authInteractor = Injector.appInstance.get<AuthInteractor>();

  AuthBloc() : super(InitialAuthState()){
    on<SignUpEvent>(_signUp);
    on<SignInEvent>(_signIn);
  }

  Future<void> _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      await _authInteractor.signUp(event.email, event.password);
      emit(AuthenticatedState());
    } on AuthException catch(exception) {
      emit(ErrorAuthState(message: exception.message));
    }
  }

  Future<void> _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      await _authInteractor.signIn(event.email, event.password);
      emit(AuthenticatedState());
    } on AuthException catch(exception) {
      emit(ErrorAuthState(message: exception.message));
    }
  }
}