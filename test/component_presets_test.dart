import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/flutterwind.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';

void main() {
  group('component presets', () {
    testWidgets('btn-primary preset applies semantic background color',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container().className('btn btn-primary'),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) => w is Container && w.decoration is BoxDecoration,
        ),
      );
      final colored = containers
          .where((c) =>
              c.decoration is BoxDecoration &&
              (c.decoration as BoxDecoration).color != null)
          .first;
      final color = (colored.decoration as BoxDecoration).color;
      expect(color, TailwindConfig.resolveColorToken('primary'));
    });

    testWidgets('explicit utility still overrides preset utility', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container().className('btn btn-primary bg-red-500'),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) => w is Container && w.decoration is BoxDecoration,
        ),
      );
      final colored = containers
          .where((c) =>
              c.decoration is BoxDecoration &&
              (c.decoration as BoxDecoration).color != null)
          .first;
      final color = (colored.decoration as BoxDecoration).color;
      expect(color, TailwindConfig.colors['red']?[500]);
    });
  });
}
