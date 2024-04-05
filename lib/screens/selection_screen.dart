import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/widgets/welcome_button.dart';
import 'package:canteen_final/screens/verify_chef.dart';
import 'package:canteen_final/screens/home_user.dart';
import 'package:canteen_final/screens/signin_screen.dart';
import 'package:canteen_final/screens/signup_screen.dart';

class SelectionScreen extends StatelessWidget{
  const SelectionScreen({super.key});

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
                            text: 'Welcome Foodies ! \n',
                            style: TextStyle(
                              fontSize: 35.0,
                              color: Color(0xFF2C1812),
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text:
                            "\n- Let's get started ",
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
                      buttonText: 'Chef',
                      onTap:  HomeChef(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'User',
                      onTap: const HomeUser(),
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