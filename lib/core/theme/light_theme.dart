import 'package:flutter/material.dart';
import 'app_colors.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        error: AppColors.error,

        surfaceContainerHighest: AppColors.surfaceVariantLight,

        primaryContainer: AppColors.CardSelectedLight,
        shadow: AppColors.shadowlight,
      ),

      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        // fillColor: AppColors.containerLight,
        fillColor: AppColors.surface,
      ),

      cardColor: AppColors.containerLight,

      dividerColor: Colors.grey,
    );
  }
}
