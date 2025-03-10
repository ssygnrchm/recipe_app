import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 57, 57, 57),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                spacing: 16,
                children: [
                  CircleAvatar(
                    maxRadius: 16,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
      ),
    );
  }
}
