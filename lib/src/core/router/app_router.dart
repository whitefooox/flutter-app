import 'package:flutter/material.dart';
import 'package:search3/src/features/auth/presentation/pages/auth_page.dart';
import 'package:search3/src/features/auth/presentation/pages/auth_signin_page.dart';
import 'package:search3/src/features/auth/presentation/pages/auth_signup_page.dart';
import 'package:search3/src/features/recognize/presentation/pages/main_page.dart';

class AppRouter {
  static const String initialRoute = "/";
  static final routes = {
    "/": (context) => const AuthPage(),
    "/signUp": (context) => const AuthSignUpPage(),
    "/signIn": (context) => const AuthSignInPage(),
    "/main": (context) => const MainPage()
  };

  static void go(BuildContext context, String path){
    switch (path) {
      case "/main":
        Navigator.pushNamedAndRemoveUntil(context, path, (route) => route.settings.name == "/");
        break;
      default:
        Navigator.pushNamed(context, path);
    }
  }

  static void goBack(BuildContext context){
    Navigator.pop(context);
  }
}