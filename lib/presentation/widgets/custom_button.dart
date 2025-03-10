import 'package:flutter/material.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title, this.onPressed});
  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 171, 75),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fixedSize:
            MediaQuery.of(context).size.width >= 768
                ? Size(MediaQuery.of(context).size.width / 2.5, 56)
                : Size(MediaQuery.of(context).size.width, 56),
      ),
      onPressed: onPressed,
      child: CustomText(
        title: title,
        fsize: 16,
        fweight: FontWeight.bold,
        fcolor: Colors.black,
      ),
    );
  }
}
