import 'package:flutter/material.dart';
import 'package:food_delivery_app/presentation/pages/home_screen.dart';
import 'package:food_delivery_app/presentation/widgets/custom_button.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';
// import 'package:food_delivery_app/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Access the current theme
    final theme = Theme.of(context);

    return Scaffold(
      // The scaffold will automatically use the theme's scaffoldBackgroundColor
      body: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(16),
        // Remove hardcoded decoration color, let theme handle it
        // decoration: BoxDecoration(
        //   // Create a gradient background
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       theme.colorScheme.background,
        //       theme.colorScheme.primary.withOpacity(0.1),
        //     ],
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Use theme text styles instead of hardcoded styles
                  CustomText.h1(
                    context,
                    "Your Favorite Food, Delivered Fast",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomText.bodySmall(
                    context,
                    "Find the best restaurants in your city and get it delivered to your place!",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Image.asset("assets/images/welcome_image.png"),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: CustomButton(
                title: "Order Now!",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
