import 'package:flutter/material.dart';

ThemeData myTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF3897F0), // Instagram blue for icons and accents
    onPrimary: Colors.white, // Text color on blue elements
    secondary: Colors.black, // Primary text color
    onSecondary: Colors
        .black87, // Text on secondary surfaces like app bar and bottom navigation
    surface:
        Color(0xFFF5F5F5), // Light gray background for post cards and surfaces
    onSurface: Colors.black87, // Text on gray surfaces
    error: Color(0xFFE53935), // Error color (red)
    onError: Colors.white, // Text on error surfaces
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.white, // AppBar background color
    iconTheme: IconThemeData(color: Colors.black), // Icons in AppBar
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 0, // Flat AppBar with no shadow
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF3897F0), // Instagram blue for primary buttons
    textTheme: ButtonTextTheme.primary,
  ),
);
