import 'package:flutter/material.dart';

class AppTheme {
  // Define color constants
  static const Color primaryTeal = Color(0xFF33724B);
  static const Color aliceBlue = Color(0xFFEAF7FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF06130D);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryTeal,
    colorScheme: ColorScheme.dark(
      primary: primaryTeal,
      secondary: aliceBlue,
      background: darkBackground,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryTeal,
      elevation: 0,
      iconTheme: const IconThemeData(color: white),
      titleTextStyle: const TextStyle(
        color: white,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryTeal,
        foregroundColor: white,
        elevation: 4,
        shadowColor: primaryTeal.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: white.withOpacity(0.9),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: const TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryTeal;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(white),
      side: BorderSide(color: white.withOpacity(0.7), width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    cardTheme: CardTheme(
      color: primaryTeal.withOpacity(0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: primaryTeal.withOpacity(0.3), width: 1),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: aliceBlue,
    primaryColor: primaryTeal,
    colorScheme: ColorScheme.light(
      primary: primaryTeal,
      secondary: primaryTeal.withOpacity(0.1),
      background: aliceBlue,
    ),
    // Rest of the theme configuration similar to dark theme
    // Customize with lighter colors and softer contrasts
  );
}