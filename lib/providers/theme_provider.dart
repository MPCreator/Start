import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme() {
    themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: LightColors.primaryColor,
      scaffoldBackgroundColor: LightColors.backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: LightColors.primaryColor,
        secondary: LightColors.secondaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: LightColors.textColor),
        bodyMedium: TextStyle(color: LightColors.textColor),
        bodySmall: TextStyle(color:LightColors.textColor),

      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: LightColors.primaryColor,
        foregroundColor: LightColors.textAppBarColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: LightColors.buttonColor,
            foregroundColor: LightColors.textColor
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: LightColors.textColor,
        iconColor: LightColors.textColor,
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      primaryColor: DarkColors.primaryColor,
      scaffoldBackgroundColor: DarkColors.backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: DarkColors.primaryColor,
        secondary: DarkColors.secondaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: DarkColors.textColor),
        bodyMedium: TextStyle(color: DarkColors.textColor),
        bodySmall: TextStyle(color: DarkColors.textColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: DarkColors.primaryColor,
        foregroundColor: DarkColors.textColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: DarkColors.buttonColor,
            foregroundColor: DarkColors.textColor
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: DarkColors.textColor,
        iconColor: DarkColors.textColor,
      ),
    );
  }
}
