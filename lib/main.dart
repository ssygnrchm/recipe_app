import 'package:flutter/material.dart';
import 'package:food_delivery_app/presentation/pages/welcome_screen.dart';
import 'package:food_delivery_app/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      title: 'Your App Name',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // You can change to .light or .dark
    );
  }
}
