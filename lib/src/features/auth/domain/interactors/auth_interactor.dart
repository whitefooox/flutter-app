import 'package:search3/src/features/auth/domain/dependencies/i_auth_service.dart';
import 'package:search3/src/features/auth/domain/entities/user.dart';
import 'package:search3/src/features/auth/domain/exceptions/auth_exception.dart';

class AuthInteractor {

  final IAuthService _authService;

  AuthInteractor(this._authService);

  Future<void> signUp(String email, String password) async {
    try {
      await _authService.signUp(User(email: email, password: password));
    } on AuthException catch(exception) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authService.signIn(User(email: email, password: password));
    } on AuthException catch(exception) {
      rethrow;
    }
  }
}