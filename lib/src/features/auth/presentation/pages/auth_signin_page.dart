import 'package:flutter/material.dart';
import 'package:search3/src/features/auth/presentation/widgets/magic_button.dart';
import 'package:search3/src/features/auth/presentation/widgets/magic_input_field.dart';

class AuthSignInPage extends StatelessWidget {

  final String backgroundImagePath = "assets/images/auth_background.jpg";

  const AuthSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MagicInputField(placeholderText: "Email",),
              const SizedBox(height: 20,),
              const MagicInputField(placeholderText: "Password", isSecret: true,),
              const SizedBox(height: 40,),
              MagicButton(text: "GO!", onClick: (){})
            ],
          ),
        ),
      )
    );
  }
}