import 'package:firebase_auth/firebase_auth.dart';
import 'package:search3/src/features/auth/domain/dependencies/i_auth_service.dart';
import 'package:search3/src/features/auth/domain/entities/user.dart' as domain;

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; 

  @override
  Future<bool> signIn(domain.User user) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> signUp(domain.User user) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}