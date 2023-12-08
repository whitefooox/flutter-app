import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search3/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:search3/src/features/auth/presentation/widgets/magic_button.dart';
import 'package:search3/src/features/auth/presentation/widgets/magic_input_field.dart';

class AuthSignInPage extends StatefulWidget {


  AuthSignInPage({super.key});

  @override
  State<AuthSignInPage> createState() => _AuthSignInPageState();
}

class _AuthSignInPageState extends State<AuthSignInPage> {
  final String backgroundImagePath = "assets/images/auth_background.jpg";

  final authBloc = AuthBloc();

  String _email = "";

  String _password = "";

  void a(String text){}

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            padding: const EdgeInsets.only(left: 50, right: 50),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset(backgroundImagePath).image,
                fit: BoxFit.fill
              )
            ),
            child: BlocBuilder(
              bloc: authBloc,
              builder: (context, state) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MagicInputField(placeholderText: "Email", onChange: (text) => setState(() => _email = text)),
                  const SizedBox(height: 20,),
                  MagicInputField(placeholderText: "Password", isSecret: true, onChange: (text) => setState(() => _password = text)),
                  const SizedBox(height: 40,),
                  MagicButton(text: "GO!", onClick: () => authBloc.add(SignInEvent(email: _email, password: _password)))
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}