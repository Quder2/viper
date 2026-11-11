import 'package:flutter/material.dart';

abstract final class SageTheme {
  static const background = Color(0xFF07131C);
  static const surface = Color(0xFF102532);
  static const elevated = Color(0xFF173746);
  static const ice = Color(0xFFBDEFFF);
  static const cyan = Color(0xFF70D8E8);
  static const jade = Color(0xFF8FE4D0);
  static const muted = Color(0xFF8CAEBB);
  static const toxicGreen = cyan;
  static const brightGreen = ice;
  static const mutedGreen = Color(0xFF315B6B);
  static const secondaryText = muted;
  static const elevatedSurface = elevated;
  static const textPrimary = Color(0xFFDBF7FF);
  static const mutedBright = Color(0xFF7397A5);
  static const mutedDeep = Color(0xFF557D8A);
  static const deepSurface = Color(0xFF101812);
  static const panelGlass = Color(0xD9102532);
  static const overlayTop = Color(0xAA07131C);
  static const overlayMid = Color(0x2207131C);
  static const overlayBottom = Color(0xFF07131C);
  static const overlayButton = Color(0xCC173746);
  static const overlayHint = Color(0xCC07131C);
  static const outlineSoft = Color(0x6670D8E8);
  static const glowStrong = Color(0x9939B9D3);
  static const glowMedium = Color(0x8839B9D3);
  static const glowSoft = Color(0x4439B9D3);
  static const glowSubtle = Color(0x2239B9D3);

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
