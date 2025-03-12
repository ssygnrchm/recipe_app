import 'package:flutter/material.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.buttonStyle,
    this.isSecondary = false,
    this.isDanger = false,
    this.isSuccess = false,
  });

  final String title;
  final void Function()? onPressed;
  final ButtonStyle? buttonStyle;
  final bool isSecondary;
  final bool isDanger;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    // Get button style based on type or use custom style if provided
    ButtonStyle getButtonStyle() {
      if (buttonStyle != null) {
        return buttonStyle!;
      } else if (isDanger) {
        return AppTheme.dangerButtonStyle;
      } else if (isSuccess) {
        return AppTheme.successButtonStyle;
      } else if (isSecondary) {
        return AppTheme.secondaryButtonStyle;
      } else {
        return AppTheme.primaryButtonStyle;
      }
    }

    // Calculate button width based on screen size
    final Size buttonSize =
        MediaQuery.of(context).size.width >= 768
            ? Size(MediaQuery.of(context).size.width / 2.5, 56)
            : Size(MediaQuery.of(context).size.width, 56);

    return ElevatedButton(
      style: getButtonStyle().copyWith(
        // Override the fixed size while keeping all other style properties
        fixedSize: WidgetStateProperty.all(buttonSize),
      ),
      onPressed: onPressed,
      child: CustomText(
        title: title,
        fsize: 16,
        fweight: FontWeight.bold,
        // Let the button style determine text color based on the theme
        fcolor: null,
      ),
    );
  }
}
