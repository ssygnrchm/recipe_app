// lib/presentation/pages/loading_screen.dart
import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/authentication/provider/auth_provider.dart';
import 'package:food_delivery_app/presentation/pages/home_screen.dart';
import 'package:food_delivery_app/presentation/pages/welcome_screen.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show loading indicator while checking authentication state
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Navigate to appropriate screen based on authentication state
        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        } else {
          return WelcomeScreen();
        }
      },
    );
  }
}
