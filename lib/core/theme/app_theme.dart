import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    
    return ThemeData(
      fontFamily: 'OpenRunde',
      fontFamilyFallback: const ['Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji'],
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryGreen,
        surface: AppColors.cardBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textLight),
        titleTextStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bottomNavBackground,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0, // Removed elevation to blend with background
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.5),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.5),
      ),
      textTheme: baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: AppColors.textLight),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        titleMedium: baseTextTheme.titleMedium?.copyWith(color: AppColors.textLight, fontWeight: FontWeight.bold),
        titleSmall: baseTextTheme.titleSmall?.copyWith(color: AppColors.textGrey),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textLight,
      ),
    );
  }
}
