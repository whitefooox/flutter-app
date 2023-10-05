import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:search3/app.dart';

void main() {
  final injector = Injector.appInstance;

  runApp(const App());
}
