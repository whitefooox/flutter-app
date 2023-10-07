import 'package:flutter/material.dart';
import 'package:search3/src/presentation/pages/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(100, 204, 197, 1)),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: const MainPage());
  }
}
