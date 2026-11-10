import 'package:flutter/material.dart';

abstract final class ViperTheme {
  static const background = Color(0xFF070B08);
  static const surface = Color(0xFF101812);
  static const toxicGreen = Color(0xFF65D84A);
  static const mutedGreen = Color(0xFF244A2B);

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: toxicGreen,
      brightness: Brightness.dark,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme.copyWith(
        primary: toxicGreen,
        secondary: const Color(0xFF9BFF83),
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface.withValues(alpha: 0.92),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: toxicGreen.withValues(alpha: 0.16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: toxicGreen,
          backgroundColor: mutedGreen.withValues(alpha: 0.55),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: toxicGreen.withValues(alpha: 0.35)),
          ),
        ),
      ),
      textTheme: Typography.whiteCupertino.apply(
        bodyColor: const Color(0xFFE1E9E2),
        displayColor: Colors.white,
      ),
    );
  }
}
