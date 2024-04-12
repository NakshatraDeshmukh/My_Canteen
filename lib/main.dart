import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:canteen_final/screens/welcome_screen.dart'; // assuming WelcomeScreen is your initial screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ssqtpwmwqypgxdubxxqs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzcXRwd213cXlwZ3hkdWJ4eHFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIyMjA3ODMsImV4cCI6MjAyNzc5Njc4M30.SFIQ0NHB8KowS26a4zwy80v0Dxl_7DzgQsXjfriSLtA',
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseClient>(
          create: (_) => Supabase.instance.client,
        ),
        // Add other providers if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Your App Title',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(), // or any other initial screen
      ),
    );
  }
}
