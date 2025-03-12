// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;
  final double? fsize;
  final FontWeight? fweight;
  final Color? fcolor;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomText({
    super.key,
    required this.title,
    this.textAlign,
    this.fsize,
    this.fweight,
    this.fcolor,
    this.letterSpacing,
    this.wordSpacing,
    this.style,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final theme = Theme.of(context);

    // If a custom style is provided, use it as the base style
    // Otherwise, use the theme's bodyMedium text style as the base
    TextStyle baseStyle =
        style ?? theme.textTheme.bodyMedium ?? const TextStyle();

    // Merge provided properties with the base style
    // Only apply custom properties if they are not null
    final mergedStyle = baseStyle.copyWith(
      fontSize: fsize,
      fontWeight: fweight,
      color: fcolor,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
    );

    return Text(
      title,
      textAlign: textAlign,
      style: mergedStyle,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Factory constructor to create CustomText from theme text style
  factory CustomText.fromTheme({
    required BuildContext context,
    required String title,
    TextAlign? textAlign,
    required TextStyle? themeStyle,
    Color? overrideColor,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return CustomText(
      title: title,
      textAlign: textAlign,
      style: themeStyle?.copyWith(color: overrideColor),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Display text style
  static CustomText display1(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText.fromTheme(
      context: context,
      title: title,
      themeStyle: Theme.of(context).textTheme.displayLarge,
      overrideColor: color,
      textAlign: textAlign,
    );
  }

  /// Heading 1 text style
  static CustomText h1(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText.fromTheme(
      context: context,
      title: title,
      themeStyle: Theme.of(context).textTheme.headlineLarge,
      overrideColor: color,
      textAlign: textAlign,
    );
  }

  /// Heading 2 text style
  static CustomText h2(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText.fromTheme(
      context: context,
      title: title,
      themeStyle: Theme.of(context).textTheme.headlineMedium,
      overrideColor: color,
      textAlign: textAlign,
    );
  }

  /// Body large text style
  static CustomText bodyLarge(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText.fromTheme(
      context: context,
      title: title,
      themeStyle: Theme.of(context).textTheme.bodyLarge,
      overrideColor: color,
      textAlign: textAlign,
    );
  }

  /// Body medium text style (default body text)
  static CustomText body(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText.fromTheme(
      context: context,
      title: title,
      themeStyle: Theme.of(context).textTheme.bodyMedium,
      overrideColor: color,
      textAlign: textAlign,
    );
  }

  /// Body small text style
  static CustomText bodySmall(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText.fromTheme(
      context: context,
      title: title,
      themeStyle: Theme.of(context).textTheme.bodySmall,
      overrideColor: color,
      textAlign: textAlign,
    );
  }

  /// Caption text style
  static CustomText caption(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText.fromTheme(
      context: context,
      title: title,
      themeStyle: Theme.of(context).textTheme.labelSmall,
      overrideColor: color,
      textAlign: textAlign,
    );
  }

  /// Button text style
  static CustomText button(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
  }) {
    return CustomText.fromTheme(
      context: context,
      title: title,
      themeStyle: Theme.of(context).textTheme.labelLarge,
      overrideColor: color,
      textAlign: textAlign,
    );
  }
}
