import 'package:flutter/material.dart';
import 'package:food_delivery_app/presentation/pages/welcome_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Raleways'),
      home: WelcomePage(),
    );
  }
}
