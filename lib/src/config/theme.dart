import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';

class FlutterWindTheme {
  static ColorScheme colorSchemeFromConfig({
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    final surface =
        TailwindConfig.getSemanticColor('surface', brightness: brightness) ??
        (isDark ? const Color(0xFF111827) : Colors.white);
    final onSurface = TailwindConfig.getSemanticColor('surface-foreground',
            brightness: brightness) ??
        (isDark ? Colors.white : Colors.black);
    final primary = TailwindConfig.getSemanticColor('primary',
            brightness: brightness) ??
        TailwindConfig.resolveColorToken('blue-500', brightness: brightness) ??
        const Color(0xFF3B82F6);
    final onPrimary = TailwindConfig.getSemanticColor('primary-foreground',
            brightness: brightness) ??
        Colors.white;
    final error = TailwindConfig.getSemanticColor('danger',
            brightness: brightness) ??
        TailwindConfig.resolveColorToken('red-500', brightness: brightness) ??
        const Color(0xFFEF4444);
    final onError = TailwindConfig.getSemanticColor('danger-foreground',
            brightness: brightness) ??
        Colors.white;

    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: TailwindConfig.getSemanticColor('muted', brightness: brightness) ??
          const Color(0xFFF3F4F6),
      onSecondary: TailwindConfig.getSemanticColor('muted-foreground',
              brightness: brightness) ??
          const Color(0xFF6B7280),
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
    );
  }

  static ThemeData themeDataFromConfig({Brightness brightness = Brightness.light}) {
    final scheme = colorSchemeFromConfig(brightness: brightness);
    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: Typography.material2021().black.apply(
            bodyColor: scheme.onSurface,
            displayColor: scheme.onSurface,
          ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
    );
  }
}

