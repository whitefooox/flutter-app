import 'package:search3/src/features/auth/domain/dependencies/i_auth_service.dart';
import 'package:search3/src/features/auth/domain/entities/user.dart';

class AuthInteractor {

  final IAuthService _authService;

  AuthInteractor(this._authService);

  Future<bool> signUp(String email, String password){
    return _authService.signIn(User(email: email, password: password));
  }

  Future<bool> signIn(String email, String password){
    return _authService.signUp(User(email: email, password: password));
  }
}