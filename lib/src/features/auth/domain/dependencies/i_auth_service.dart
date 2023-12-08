import 'package:search3/src/features/auth/domain/entities/user.dart';

abstract class IAuthService {
  Future<void> signIn(User user);
  Future<void> signUp(User user);
  Future<void> signOut(User user);
}