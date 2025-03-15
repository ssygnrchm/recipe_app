import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/assets.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';
import 'package:food_delivery_app/presentation/widgets/custom_text.dart';

class FullWidthCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const FullWidthCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.secondary,
      elevation: 2,
      child: Container(
        constraints: BoxConstraints(minHeight: 200),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 24,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(image, height: 147, fit: BoxFit.contain)],
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: title,
                    style: AppTextStyles.paragraphLargeBold,
                  ),
                  CustomText(
                    title: subtitle,
                    style: AppTextStyles.paragraphSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
