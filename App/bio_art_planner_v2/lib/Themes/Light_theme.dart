import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFF5F5F5), // Light gray for app bar
    foregroundColor: Color(0xFF212121), // Dark gray for text/icons
  ),
  colorScheme: ColorScheme.light(
    surface: Color(0xFFF7F7F7), // Light gray for surfaces
    primary: Color(0xFF90CAF9), // Muted blue for primary actions
    onPrimary: Colors.black, // Contrast text for primary buttons
    secondary: Color(0xFFFFCC80), // Soft pastel orange for secondary accents
    onSecondary: Colors.black, // Contrast text for secondary buttons
    error: Color(0xFFB00020), // Subtle red for error states
    onError: Colors.white, // Contrast for error messages
    background: Color(0xFFFFFFFF), // Clean white background
    onBackground: Color(0xFF212121), // Dark gray for text on background
    onSurface: Color(0xFF212121), // Dark gray for text on surfaces
  ),
  scaffoldBackgroundColor: Color(0xFFFFFFFF), // Pure white for background
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Color(0xFF90CAF9), // Muted blue for buttons
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFF212121), // Dark gray for text buttons
      textStyle: TextStyle(fontSize: 14),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Color(0xFF212121), // Dark gray for outlined buttons
      side: BorderSide(color: Color(0xFF90CAF9)), // Muted blue border
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFCC80), // Pastel orange for FAB
    foregroundColor: Colors.black,
  ),
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    bodySmall: TextStyle(color: Color(0xFF212121)), // Dark gray text
    bodyMedium: TextStyle(color: Color(0xFF212121)),
    bodyLarge: TextStyle(color: Color(0xFF212121)),
    headlineLarge: TextStyle(color: Color(0xFF212121)),
    headlineMedium: TextStyle(color: Color(0xFF212121)),
    headlineSmall: TextStyle(color: Color(0xFF212121)),
    titleLarge: TextStyle(color: Color(0xFF212121)),
    titleMedium: TextStyle(color: Color(0xFF212121)),
    titleSmall: TextStyle(color: Color(0xFF212121)),
    displayLarge: TextStyle(color: Color(0xFF212121)),
    displayMedium: TextStyle(color: Color(0xFF212121)),
    displaySmall: TextStyle(color: Color(0xFF212121)),
    labelSmall: TextStyle(color: Color(0xFF212121)),
    labelMedium: TextStyle(color: Color(0xFF212121)),
    labelLarge: TextStyle(color: Color(0xFF212121)),
  ),
);
