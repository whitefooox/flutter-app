import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:search3/src/core/presentation/app.dart';
import 'package:search3/src/core/inject/inject.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  inject();
  runApp(const App());
}
