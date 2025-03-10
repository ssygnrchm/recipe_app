import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/typography.dart';

class AppTextStyles {
  // Text color defaults to black, but can be customized
  static const Color _defaultTextColor = Colors.black;

  // Hero
  static const TextStyle hero = TextStyle(
    fontSize: AppTypography.hero,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.tightLineHeight,
    letterSpacing: -0.5,
  );

  // Display styles
  static const TextStyle display1 = TextStyle(
    fontSize: AppTypography.display1,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.tightLineHeight,
    letterSpacing: -0.5,
  );

  static const TextStyle display2 = TextStyle(
    fontSize: AppTypography.display2,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.tightLineHeight,
    letterSpacing: -0.5,
  );

  static const TextStyle display3 = TextStyle(
    fontSize: AppTypography.display3,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.tightLineHeight,
    letterSpacing: -0.25,
  );

  // Heading styles
  static const TextStyle heading1 = TextStyle(
    fontSize: AppTypography.heading1,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.tightLineHeight,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: AppTypography.heading2,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.tightLineHeight,
  );

  // Paragraph styles - Large
  static const TextStyle paragraphLarge = TextStyle(
    fontSize: AppTypography.paragraphLarge,
    fontWeight: AppTypography.regular,
    color: _defaultTextColor,
    height: AppTypography.normalLineHeight,
  );

  static const TextStyle paragraphLargeBold = TextStyle(
    fontSize: AppTypography.paragraphLarge,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.normalLineHeight,
  );

  // Paragraph styles - Medium
  static const TextStyle paragraphMedium = TextStyle(
    fontSize: AppTypography.paragraphMedium,
    fontWeight: AppTypography.regular,
    color: _defaultTextColor,
    height: AppTypography.normalLineHeight,
  );

  static const TextStyle paragraphMediumBold = TextStyle(
    fontSize: AppTypography.paragraphMedium,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.normalLineHeight,
  );

  // Paragraph styles - Small
  static const TextStyle paragraphSmall = TextStyle(
    fontSize: AppTypography.paragraphSmall,
    fontWeight: AppTypography.regular,
    color: _defaultTextColor,
    height: AppTypography.normalLineHeight,
  );

  static const TextStyle paragraphSmallBold = TextStyle(
    fontSize: AppTypography.paragraphSmall,
    fontWeight: AppTypography.bold,
    color: _defaultTextColor,
    height: AppTypography.normalLineHeight,
  );

  // Button styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: AppTypography.buttonLarge,
    fontWeight: AppTypography.semiBold,
    color: Colors.white, // Button text is typically white on colored background
    letterSpacing: 0.5,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: AppTypography.buttonMedium,
    fontWeight: AppTypography.semiBold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: AppTypography.buttonSmall,
    fontWeight: AppTypography.semiBold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // Helper method to change the color of any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
}
