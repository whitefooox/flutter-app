import 'package:firebase_auth/firebase_auth.dart';
import 'package:search3/src/features/auth/domain/dependencies/i_auth_service.dart';
import 'package:search3/src/features/auth/domain/entities/user.dart' as domain;
import 'package:search3/src/features/auth/domain/exceptions/auth_exception.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; 

  @override
  Future<void> signIn(domain.User user) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
    } 
    on FirebaseAuthException catch (exception){
      switch (exception.code) {
        case "invalid-email":
          throw AuthException("Invalid email");
        case "user-disabled":
          throw AuthException("User disabled");
        case "user-not-found":
          throw AuthException("User not found");
        case "wrong-password":
          throw AuthException("Wrong password");
        default:
          throw AuthException("Something broke...");
      }
    }
    catch (e) {
      throw AuthException("Unknown error");
    }
  }
  
  @override
  Future<void> signUp(domain.User user) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
    }
    on FirebaseAuthException catch (exception){
      switch (exception.code) {
        case "email-already-in-use":
          throw AuthException("Email already in us");
        case "invalid-email":
          throw AuthException("Invalid email");
        case "operation-not-allowed":
          throw AuthException("Operation not allowed");
        case "weak-password":
          throw AuthException("Weak password");
        default:
          throw AuthException("Something broke...");
      }
    }
    catch (e) {
      throw AuthException("Unknown error");
    }
  }
  
  @override
  Future<void> signOut(domain.User user) {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}