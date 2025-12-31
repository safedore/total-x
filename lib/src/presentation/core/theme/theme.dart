import 'package:flutter/services.dart';
import 'package:totalx/src/presentation/core/theme/color.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.light(secondary: AppColors.secondaryColor),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    ),
  );
  static final darkTheme = ThemeData(
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(color: Colors.black),
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    ),
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.dark(secondary: AppColors.secondaryColor),
  );
}
