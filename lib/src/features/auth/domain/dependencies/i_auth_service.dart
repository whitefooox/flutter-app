import 'package:search3/src/features/auth/domain/entities/user.dart';

abstract class IAuthService {
  Future<bool> signIn(User user);
  Future<bool> signUp(User user);
}