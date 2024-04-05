import 'dart:ffi';

import 'package:canteen_final/screens/selection_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:canteen_final/screens/welcome_screen.dart';
import 'package:canteen_final/theme/theme.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
 // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      home: const WelcomeScreen(),
    );
  }
}