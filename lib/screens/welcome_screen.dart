import 'package:flutter/material.dart';
import 'package:canteen_final/screens/signin_screen.dart';
import 'package:canteen_final/screens/signup_screen.dart';
import 'package:canteen_final/theme/theme.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Reserve & Relish ! \n',
                            style: TextStyle(
                              fontSize: 41.0,
                              color: Color(0xFF2C1812),
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text:
                            "\n- Your Canteen's Best Ally",
                            style: TextStyle(
                              fontSize: 19,
                              color: Color(0xFF2C1812),
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: Color(0xFF2C1812)
                      ,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}