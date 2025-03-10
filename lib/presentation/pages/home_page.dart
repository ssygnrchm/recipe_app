import 'package:flutter/material.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              spacing: 16,
              children: [
                CircleAvatar(
                  maxRadius: 16,
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            Text("data"),
            Text("data"),
          ],
        ),
      ),
    );
  }
}
