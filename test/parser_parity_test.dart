import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/flutterwind.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

void main() {
  group('runtime parity semantics', () {
    test('last utility wins for conflicts', () {
      final style = FlutterWindStyle();
      applyClassToStyle('p-2', style);
      applyClassToStyle('p-4', style);
      expect(style.padding, const EdgeInsets.all(16.0));
    });

    testWidgets('responsive + hover chained variants resolve correctly',
        (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(900, 800);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body:
                Container().className('bg-blue-500 md:hover:bg-red-500'),
          ),
        ),
      );

      Color? currentColor() {
        final candidates = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (w) => w is Container && w.decoration is BoxDecoration,
          ),
        );
        for (final candidate in candidates) {
          final decoration = candidate.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            return decoration.color;
          }
        }
        return null;
      }

      expect(currentColor(), TailwindConfig.colors['blue']?[500]);

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer();
      final interactiveRegion = find.byWidgetPredicate(
        (w) => w is MouseRegion && w.cursor == SystemMouseCursors.click,
      );
      await mouse.moveTo(tester.getCenter(interactiveRegion));
      await tester.pumpAndSettle();

      expect(currentColor(), TailwindConfig.colors['red']?[500]);
    });

    testWidgets('hover + active requires both states', (tester) async {
      // Use a concrete box widget so background utilities are observable.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container()
                .className('bg-blue-500 hover:active:bg-red-500'),
          ),
        ),
      );

      Color? currentColor() {
        final candidates = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (w) => w is Container && w.decoration is BoxDecoration,
          ),
        );
        for (final candidate in candidates) {
          final decoration = candidate.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            return decoration.color;
          }
        }
        return null;
      }

      expect(currentColor(), TailwindConfig.colors['blue']?[500]);

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer();
      final interactiveRegion = find.byWidgetPredicate(
        (w) => w is MouseRegion && w.cursor == SystemMouseCursors.click,
      );
      final center = tester.getCenter(interactiveRegion);
      await mouse.moveTo(center);
      await tester.pump();
      expect(currentColor(), TailwindConfig.colors['blue']?[500]);

      await mouse.down(center);
      await tester.pump();
      expect(currentColor(), TailwindConfig.colors['red']?[500]);

      await mouse.up();
      await tester.pump();
      expect(currentColor(), TailwindConfig.colors['blue']?[500]);
    });

    testWidgets('group-hover applies child utility from parent hover',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: Container().className('bg-blue-500 group-hover:bg-red-500'),
            ).className('group p-2'),
          ),
        ),
      );

      Color? currentColor() {
        final candidates = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (w) => w is Container && w.decoration is BoxDecoration,
          ),
        );
        for (final candidate in candidates) {
          final decoration = candidate.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            return decoration.color;
          }
        }
        return null;
      }

      expect(currentColor(), TailwindConfig.colors['blue']?[500]);

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer();

      final groupRegion = find.byWidgetPredicate(
        (w) => w is MouseRegion,
      ).first;
      await mouse.moveTo(tester.getCenter(groupRegion));
      await tester.pumpAndSettle();

      expect(currentColor(), TailwindConfig.colors['red']?[500]);
    });

    testWidgets('group-hover + active requires group hover and active',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: Container()
                  .className('bg-blue-500 group-hover:active:bg-red-500'),
            ).className('group p-2'),
          ),
        ),
      );

      Color? currentColor() {
        final candidates = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (w) => w is Container && w.decoration is BoxDecoration,
          ),
        );
        for (final candidate in candidates) {
          final decoration = candidate.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            return decoration.color;
          }
        }
        return null;
      }

      expect(currentColor(), TailwindConfig.colors['blue']?[500]);

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer();

      final groupRegion = find.byWidgetPredicate((w) => w is MouseRegion).first;
      final center = tester.getCenter(groupRegion);
      await mouse.moveTo(center);
      await tester.pump();
      // Hover only is not enough because active is also required.
      expect(currentColor(), TailwindConfig.colors['blue']?[500]);

      await mouse.down(center);
      await tester.pump();
      expect(currentColor(), TailwindConfig.colors['red']?[500]);
    });

    testWidgets('group-active applies while group is pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: Container().className('bg-blue-500 group-active:bg-red-500'),
            ).className('group p-2'),
          ),
        ),
      );

      Color? currentColor() {
        final candidates = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (w) => w is Container && w.decoration is BoxDecoration,
          ),
        );
        for (final candidate in candidates) {
          final decoration = candidate.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            return decoration.color;
          }
        }
        return null;
      }

      expect(currentColor(), TailwindConfig.colors['blue']?[500]);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer();

      final groupRegion = find.byWidgetPredicate((w) => w is MouseRegion).first;
      final center = tester.getCenter(groupRegion);
      await mouse.down(center);
      await tester.pump();
      expect(currentColor(), TailwindConfig.colors['red']?[500]);
      await mouse.up();
    });

    testWidgets('peer-hover applies from peer host state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: Container().className('bg-blue-500 peer-hover:bg-red-500'),
            ).className('peer p-2'),
          ),
        ),
      );

      Color? currentColor() {
        final candidates = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (w) => w is Container && w.decoration is BoxDecoration,
          ),
        );
        for (final candidate in candidates) {
          final decoration = candidate.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            return decoration.color;
          }
        }
        return null;
      }

      expect(currentColor(), TailwindConfig.colors['blue']?[500]);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer();
      final peerRegion = find.byWidgetPredicate((w) => w is MouseRegion).first;
      await mouse.moveTo(tester.getCenter(peerRegion));
      await tester.pump();
      expect(currentColor(), TailwindConfig.colors['red']?[500]);
    });

    testWidgets('input-disabled:opacity shorthand applies on disabled input',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(enabled: false)
                .className('opacity-100 input-disabled:opacity'),
          ),
        ),
      );

      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacityWidget.opacity, closeTo(0.5, 0.0001));
    });

    testWidgets('focus-visible differs from plain focus', (tester) async {
      final focusNode = FocusNode(debugLabel: 'focus-visible-node');
      addTearDown(focusNode.dispose);
      final previousHighlightStrategy = FocusManager.instance.highlightStrategy;
      addTearDown(() {
        FocusManager.instance.highlightStrategy = previousHighlightStrategy;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              focusNode: focusNode,
            ).className('bg-blue-500 focus-visible:bg-red-500 focus:bg-green-500'),
          ),
        ),
      );

      Color? currentColor() {
        final candidates = tester.widgetList<Container>(
          find.byWidgetPredicate(
            (w) => w is Container && w.decoration is BoxDecoration,
          ),
        );
        for (final candidate in candidates) {
          final decoration = candidate.decoration;
          if (decoration is BoxDecoration && decoration.color != null) {
            return decoration.color;
          }
        }
        return null;
      }

      expect(currentColor(), TailwindConfig.colors['blue']?[500]);

      // Touch strategy: focus is active but focus-visible is suppressed.
      FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTouch;
      focusNode.requestFocus();
      await tester.pump();
      expect(currentColor(), TailwindConfig.colors['green']?[500]);

      focusNode.unfocus();
      await tester.pump();

      // Traditional strategy in tests still keeps focus-visible separate from
      // plain focus; focus utility remains active and deterministic.
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      focusNode.requestFocus();
      await tester.pump();
      expect(currentColor(), TailwindConfig.colors['green']?[500]);
    });

    test('arbitrary utilities parse to runtime values', () {
      final style = FlutterWindStyle();
      applyClassToStyle('w-[10rem]', style);
      expect(style.width, 160.0);

      final opacityStyle = FlutterWindStyle();
      applyClassToStyle('opacity-[35]', opacityStyle);
      expect(opacityStyle.opacity, closeTo(0.35, 0.0001));
    });
  });
}
