import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A), // Dark gray with slight warmth
    foregroundColor: Color(0xFFE0E0E0), // Softer white for text
  ),
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF1E1E1E), // Slightly lighter for surfaces
    primary: Color(0xFFfde0d9), // Softer white for primary actions
    onPrimary: Colors.black, // Contrast text for primary buttons
    secondary: Color(0xFFcaf4f4), // Muted teal for secondary accents
    onSecondary: Colors.black, // Contrast text for secondary buttons
    error: Color(0xFFCF6679), // Muted red for error states
    onError: Colors.black,
    background: Color(0xFF121212), // Slightly brightened dark gray
    onBackground: Color(0xFFE0E0E0), // Soft gray for text on background
    onSurface: Color(0xFFE0E0E0), // Light gray for text on surfaces
  ),
  scaffoldBackgroundColor: Color(0xFF181818), // Slightly lighter dark background
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Color(0xFFfde0d9), // Softer white for buttons
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
      foregroundColor: Color(0xFFF5F5F5), // Softer white for text buttons
      textStyle: TextStyle(fontSize: 14),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Color(0xFFF5F5F5), // Softer white for outlined buttons
      side: BorderSide(color: Color(0xFFfde0d9)),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFfde0d9), // Softer white for FAB
    foregroundColor: Colors.black,
  ),
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    bodySmall: TextStyle(color: Color(0xFFE0E0E0)), // Light gray for text
    bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
    headlineLarge: TextStyle(color: Color(0xFFE0E0E0)),
    headlineMedium: TextStyle(color: Color(0xFFE0E0E0)),
    headlineSmall: TextStyle(color: Color(0xFFE0E0E0)),
    titleLarge: TextStyle(color: Color(0xFFE0E0E0)),
    titleMedium: TextStyle(color: Color(0xFFE0E0E0)),
    titleSmall: TextStyle(color: Color(0xFFE0E0E0)),
    displayLarge: TextStyle(color: Color(0xFFE0E0E0)),
    displayMedium: TextStyle(color: Color(0xFFE0E0E0)),
    displaySmall: TextStyle(color: Color(0xFFE0E0E0)),
    labelSmall: TextStyle(color: Color(0xFFE0E0E0)),
    labelMedium: TextStyle(color: Color(0xFFE0E0E0)),
    labelLarge: TextStyle(color: Color(0xFFE0E0E0)),
  ),
);
