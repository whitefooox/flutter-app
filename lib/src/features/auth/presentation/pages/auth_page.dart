import 'package:flutter/material.dart';
import 'package:search3/src/core/config/files.dart';
import 'package:search3/src/core/router/app_router.dart';
import 'package:search3/src/features/auth/presentation/widgets/magic_button.dart';

class AuthPage extends StatelessWidget {

  const AuthPage({super.key});

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
              image: Image.asset(AUTH_BACKGROUND_IMAGE_PATH).image,
              fit: BoxFit.fill
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome\nto MagicScan!",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              Image.asset(
                AUTH_RABBIT_IMAGE_PATH,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 40,),
              MagicButton(text: "Sign in", onClick: () => AppRouter.go(context, "/signIn")),
              const SizedBox(height: 20,),
              MagicButton(text: "Sign up", onClick: () => AppRouter.go(context, "/signUp")),
            ],
          )
        )
      ),
    );
  }
}