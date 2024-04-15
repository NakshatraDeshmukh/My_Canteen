import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/widgets/welcome_button.dart';
import 'package:canteen_final/screens/verify_chef.dart';
import 'package:canteen_final/screens/home_user.dart';
import 'package:canteen_final/screens/signin_screen.dart';
import 'package:canteen_final/screens/signup_screen.dart';
import 'package:canteen_final/screens/account_page.dart';
import 'package:supabase/supabase.dart';

class SelectionScreen extends StatelessWidget {
  final SupabaseClient supabase;
  const SelectionScreen({Key? key, required this.supabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('My Canteen'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle), // Profile icon
            onPressed: () {
              // Navigate to UserProfileScreen when profile icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
            color: Colors.brown,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/welcome_page.png'), // Replace 'assets/welcome_page.png' with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
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
                          ),
                        ),
                        TextSpan(
                          text: "\n- Let's get started ",
                          style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF2C1812),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to the end
              children: [
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Chef',
                    onTap: HomeChef(),
                    color: Colors.transparent,
                    textColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'User',
                    onTap: HomeUser(supabase: supabase),
                    color: Colors.white,
                    textColor: Color(0xFF2C1812),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
