import 'package:flutter/material.dart';
import 'package:food_delivery_app/presentation/pages/home_page.dart';
import 'package:food_delivery_app/presentation/widgets/custom_button.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Color.fromARGB(255, 57, 57, 57)),
        child: Column(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomText(
                    title: "Your Favorite Food, Delivered Fast",
                    fsize: 32,
                    fcolor: Colors.white,
                    fweight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  CustomText(
                    title:
                        "Find the best restaurants in your city and get it delivered to your place!",
                    fsize: 14,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Image.asset("assets/images/welcome_image.png"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: CustomButton(
                title: "Order Now!",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
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
