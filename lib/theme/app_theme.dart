import 'package:flutter/material.dart';

class AppTheme {
  // Modern 2025 Color Palette
  static const Color _primaryLight = Color(0xFF6366F1); // Indigo
  static const Color _secondaryLight = Color(0xFFA855F7); // Purple
  static const Color _surfaceLight = Color(0xFFF8FAFC);
  
  static const Color _primaryDark = Color(0xFF818CF8); // Lighter Indigo
  static const Color _secondaryDark = Color(0xFFC084FC); // Lighter Purple
  static const Color _surfaceDark = Color(0xFF1E293B);
  static const Color _backgroundDark = Color(0xFF0F172A);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: _primaryLight,
      secondary: _secondaryLight,
      surface: _surfaceLight,
      error: const Color(0xFFEF4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF0F172A),
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      color: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryLight,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF0F172A),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF334155)),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF475569)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)),
    ),
    scaffoldBackgroundColor: _surfaceLight,
    iconTheme: const IconThemeData(color: _primaryLight),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: _primaryDark,
      secondary: _secondaryDark,
      surface: _surfaceDark,
      error: const Color(0xFFF87171),
      onPrimary: const Color(0xFF0F172A),
      onSecondary: const Color(0xFF0F172A),
      onSurface: const Color(0xFFF1F5F9),
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: Color(0xFF374151), width: 1),
      ),
      color: _surfaceDark,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryDark,
      foregroundColor: const Color(0xFF0F172A),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFF1F5F9),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Color(0xFFF1F5F9)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFFF1F5F9)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFCBD5E1)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFE2E8F0)),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFFCBD5E1)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFF1F5F9)),
    ),
    scaffoldBackgroundColor: _backgroundDark,
    iconTheme: const IconThemeData(color: _primaryDark),
  );
}
