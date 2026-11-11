import 'package:flutter/material.dart';

abstract final class ViperTheme {
  static const background = Color(0xFF030A06);
  static const surface = Color(0xFF0B1710);
  static const elevatedSurface = Color(0xFF102719);
  static const toxicGreen = Color(0xFF9BFF83);
  static const brightGreen = Color(0xFFB8FF9B);
  static const mutedGreen = Color(0xFF244A2B);
  static const secondaryText = Color(0xFF9BB5A0);

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: toxicGreen,
      brightness: Brightness.dark,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme.copyWith(
        primary: toxicGreen,
        onPrimary: background,
        secondary: brightGreen,
        onSecondary: background,
        surface: surface,
        onSurface: const Color(0xFFE2FFD8),
        error: const Color(0xFFFF6B6B),
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Color(0xFFE2FFD8),
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: surface.withValues(alpha: .94),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: toxicGreen.withValues(alpha: .17)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: toxicGreen.withValues(alpha: .14),
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: brightGreen),
      sliderTheme: const SliderThemeData(
        activeTrackColor: toxicGreen,
        inactiveTrackColor: Colors.white12,
        thumbColor: brightGreen,
        overlayColor: Color(0x229BFF83),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: brightGreen,
          backgroundColor: elevatedSurface,
          disabledForegroundColor: Colors.white38,
          disabledBackgroundColor: surface,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: .7,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: BorderSide(color: toxicGreen.withValues(alpha: .38)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brightGreen,
          side: BorderSide(color: toxicGreen.withValues(alpha: .4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      textTheme: Typography.whiteCupertino.apply(
        bodyColor: secondaryText,
        displayColor: const Color(0xFFE2FFD8),
      ),
    );
  }
}
