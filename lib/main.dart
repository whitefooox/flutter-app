import 'package:flutter/material.dart';
import 'package:search3/src/core/presentation/app.dart';
import 'package:search3/src/core/inject/inject.dart';

void main() async {
  inject();
  runApp(const App());
}
