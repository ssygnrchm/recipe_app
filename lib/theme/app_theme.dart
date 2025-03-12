// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/core/constants/colors.dart';
import 'package:food_delivery_app/core/constants/text_styles.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.warning,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: AppColors.warning,
        secondary: AppColors.accentBlue,
        error: AppColors.danger,
        background: Colors.white,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: AppColors.inkDarkest,
        onSurface: AppColors.inkDarkest,
        onBackground: AppColors.inkDarkest,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.inkDarkest,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTextStyles.heading2,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.warning,
          side: BorderSide(color: AppColors.warning),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.warning,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      iconTheme: IconThemeData(color: AppColors.inkDark, size: 24),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display1,
        displayMedium: AppTextStyles.display2,
        displaySmall: AppTextStyles.display3,
        headlineLarge: AppTextStyles.heading1,
        headlineMedium: AppTextStyles.heading2,
        titleLarge: AppTextStyles.paragraphLargeBold,
        titleMedium: AppTextStyles.paragraphMediumBold,
        titleSmall: AppTextStyles.paragraphSmallBold,
        bodyLarge: AppTextStyles.paragraphLarge,
        bodyMedium: AppTextStyles.paragraphMedium,
        bodySmall: AppTextStyles.paragraphSmall,
        labelLarge: AppTextStyles.buttonLarge,
        labelMedium: AppTextStyles.buttonMedium,
        labelSmall: AppTextStyles.buttonSmall,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inkLightest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.warning, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.danger, width: 2),
        ),
        labelStyle: AppTextStyles.withColor(
          AppTextStyles.paragraphMedium,
          AppColors.inkDark,
        ),
        hintStyle: AppTextStyles.withColor(
          AppTextStyles.paragraphMedium,
          AppColors.inkMedium,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.inkLight,
        thickness: 1,
        space: 24,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.inkLightest,
        disabledColor: AppColors.inkLight,
        selectedColor: AppColors.warning,
        secondarySelectedColor: AppColors.warning,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: AppTextStyles.paragraphSmall,
        secondaryLabelStyle: AppTextStyles.paragraphSmall,
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.warning,
      scaffoldBackgroundColor: AppColors.inkDarkest,
      cardColor: Color(0xFF1E1E1E),
      colorScheme: ColorScheme.dark(
        primary: AppColors.warning,
        secondary: AppColors.accentBlue,
        error: AppColors.danger,
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        onPrimary: AppColors.inkDarkest,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.withColor(
          AppTextStyles.heading2,
          Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Color(0xFF1E1E1E),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: AppColors.warning),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.warning,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white, size: 24),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.withColor(
          AppTextStyles.display1,
          Colors.white,
        ),
        displayMedium: AppTextStyles.withColor(
          AppTextStyles.display2,
          Colors.white,
        ),
        displaySmall: AppTextStyles.withColor(
          AppTextStyles.display3,
          Colors.white,
        ),
        headlineLarge: AppTextStyles.withColor(
          AppTextStyles.heading1,
          Colors.white,
        ),
        headlineMedium: AppTextStyles.withColor(
          AppTextStyles.heading2,
          Colors.white,
        ),
        titleLarge: AppTextStyles.withColor(
          AppTextStyles.paragraphLargeBold,
          Colors.white,
        ),
        titleMedium: AppTextStyles.withColor(
          AppTextStyles.paragraphMediumBold,
          Colors.white,
        ),
        titleSmall: AppTextStyles.withColor(
          AppTextStyles.paragraphSmallBold,
          Colors.white,
        ),
        bodyLarge: AppTextStyles.withColor(
          AppTextStyles.paragraphLarge,
          Colors.white,
        ),
        bodyMedium: AppTextStyles.withColor(
          AppTextStyles.paragraphMedium,
          Colors.white,
        ),
        bodySmall: AppTextStyles.withColor(
          AppTextStyles.paragraphSmall,
          Colors.white,
        ),
        labelLarge: AppTextStyles.withColor(
          AppTextStyles.buttonLarge,
          Colors.white,
        ),
        labelMedium: AppTextStyles.withColor(
          AppTextStyles.buttonMedium,
          Colors.white,
        ),
        labelSmall: AppTextStyles.withColor(
          AppTextStyles.buttonSmall,
          Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.warning, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.danger, width: 2),
        ),
        labelStyle: AppTextStyles.withColor(
          AppTextStyles.paragraphMedium,
          Colors.white70,
        ),
        hintStyle: AppTextStyles.withColor(
          AppTextStyles.paragraphMedium,
          Colors.white54,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Color(0xFF3A3A3A),
        thickness: 1,
        space: 24,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFF2A2A2A),
        disabledColor: Color(0xFF3A3A3A),
        selectedColor: AppColors.warning,
        secondarySelectedColor: AppColors.warning,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: AppTextStyles.withColor(
          AppTextStyles.paragraphSmall,
          Colors.white,
        ),
        secondaryLabelStyle: AppTextStyles.withColor(
          AppTextStyles.paragraphSmall,
          Colors.white,
        ),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Custom Card Styles
  static CardTheme get featuredCardTheme {
    return CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
    );
  }

  // Custom Button Styles
  static ButtonStyle get primaryButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.warning,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: AppTextStyles.buttonMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static ButtonStyle get secondaryButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.inkLightest,
      foregroundColor: AppColors.inkDarkest,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: AppTextStyles.buttonMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static ButtonStyle get successButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.success,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: AppTextStyles.buttonMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static ButtonStyle get dangerButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.danger,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: AppTextStyles.buttonMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Download button style based on your design mockups
  static ButtonStyle downloadButtonStyle({bool isDark = false}) {
    return ElevatedButton.styleFrom(
      backgroundColor: isDark ? AppColors.warning : AppColors.inkDarkest,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: AppTextStyles.buttonMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}
