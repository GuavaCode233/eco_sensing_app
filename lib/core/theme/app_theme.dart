import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_decorations.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.greenAccent,
      onPrimary: AppColors.white,
      secondary: AppColors.starbucksGreen,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.textPrimary,
      error: AppColors.red,
      onError: AppColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.neutralWarm,
      fontFamily: '.AppleSystemUIFont',
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.houseGreen,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenAccent,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.greenAccent,
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: const BorderSide(color: AppColors.greenAccent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDecorations.pillRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.greenAccent,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          letterSpacing: -0.16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
          borderSide: BorderSide(color: AppColors.ceramic),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
          borderSide: BorderSide(color: AppColors.ceramic),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
          borderSide: const BorderSide(color: AppColors.greenAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.houseGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.greenAccent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.16,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          letterSpacing: -0.16,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.white;
          return AppColors.ceramic;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.greenAccent;
          return AppColors.ceramic;
        }),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.greenAccent,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.greenAccent,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.16),
      ),
      dividerColor: AppColors.ceramic,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.greenAccent,
        linearTrackColor: AppColors.ceramic,
      ),
    );
  }

  static const TextTheme _textTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      letterSpacing: -0.24,
      height: 1.2,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      letterSpacing: -0.2,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w600,
      color: AppColors.starbucksGreen,
      letterSpacing: -0.19,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      letterSpacing: -0.16,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      letterSpacing: -0.14,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      letterSpacing: -0.16,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      letterSpacing: -0.14,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      letterSpacing: -0.13,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.14,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      letterSpacing: -0.11,
    ),
  );
}
