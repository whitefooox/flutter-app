import 'package:flutter/material.dart';
import 'package:search3/src/injection_container.dart';
import 'package:search3/src/presentation/app.dart';

void main() {
  InjectorContainer();
  runApp(const App());
}
