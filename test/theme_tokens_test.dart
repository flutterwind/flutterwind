import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/config/theme.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

void main() {
  group('semantic token api', () {
    test('resolves semantic and scale color tokens', () {
      TailwindConfig.semanticColors = {
        ...TailwindConfig.semanticColors,
        'surface': const Color(0xFF101010),
      };

      expect(TailwindConfig.resolveColorToken('surface'), const Color(0xFF101010));
      expect(
        TailwindConfig.resolveColorToken('blue-500'),
        TailwindConfig.colors['blue']?[500],
      );
    });

    test('theme bridge builds from semantic tokens', () {
      TailwindConfig.semanticColors = {
        ...TailwindConfig.semanticColors,
        'surface': const Color(0xFF222222),
        'surface-foreground': const Color(0xFFEFEFEF),
        'primary': const Color(0xFF3366FF),
      };
      final theme = FlutterWindTheme.themeDataFromConfig();
      expect(theme.colorScheme.surface, const Color(0xFF222222));
      expect(theme.colorScheme.onSurface, const Color(0xFFEFEFEF));
      expect(theme.colorScheme.primary, const Color(0xFF3366FF));
    });

    test('token v2 resolution supports dark semantic set', () {
      TailwindConfig.semanticColorsDark = {
        ...TailwindConfig.semanticColorsDark,
        'surface': const Color(0xFF0F172A),
      };

      final darkResolved = TailwindConfig.resolveColorToken(
        'surface',
        brightness: Brightness.dark,
      );
      expect(darkResolved, const Color(0xFF0F172A));
    });

    test('semantic utilities map to style properties', () {
      final style = FlutterWindStyle();
      applyClassToStyle('bg-surface', style);
      applyClassToStyle('text-muted', style);

      expect(style.backgroundColor, TailwindConfig.resolveColorToken('surface'));
      expect(style.textColor, TailwindConfig.resolveColorToken('muted'));
    });
  });
}
