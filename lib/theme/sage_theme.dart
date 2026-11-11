import 'package:flutter/material.dart';

abstract final class SageTheme {
  static const background = Color(0xFF07131C);
  static const surface = Color(0xFF102532);
  static const elevated = Color(0xFF173746);
  static const ice = Color(0xFFBDEFFF);
  static const cyan = Color(0xFF70D8E8);
  static const jade = Color(0xFF8FE4D0);
  static const muted = Color(0xFF8CAEBB);

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: cyan,
      brightness: Brightness.dark,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: scheme.copyWith(
        primary: cyan,
        secondary: jade,
        surface: surface,
        onSurface: ice,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: ice,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: cyan.withValues(alpha: .2)),
        ),
      ),
    );
  }
}
