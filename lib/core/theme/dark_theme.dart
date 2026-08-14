import 'package:flutter/material.dart';
import 'app_colors.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.darkSurface,
        error: AppColors.error,

        primaryContainer: AppColors.CardSelectedDark,
        surfaceContainerHighest: AppColors.surfaceVariantDark,

        shadow: AppColors.shadowdark,
      ),

      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        // fillColor: AppColors.containertDark,
        fillColor: AppColors.CardSelectedDark,
      ),

      cardColor: AppColors.containertDark,
    );
  }
}
