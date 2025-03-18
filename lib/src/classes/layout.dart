import 'package:flutter/material.dart';
import 'package:flutterwinds/src/utils/parser.dart';

extension FlutterWindFlexExtension on Iterable<Widget> {
  Widget className(String classString) {
    final classes = classString.split(RegExp(r'\s+'));

    // Process flex-related classes:
    bool isColumn = classes.contains('flex-col');
    // Default to row if neither flex-col nor flex-row is specified.
    if (!classes.contains('flex-col') && !classes.contains('flex-row')) {
      isColumn = false;
    }

    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
    double? gap;

    for (final c in classes) {
      if (c.startsWith('justify-')) {
        final value = c.substring('justify-'.length);
        switch (value) {
          case 'center':
            mainAxisAlignment = MainAxisAlignment.center;
            break;
          case 'between':
            mainAxisAlignment = MainAxisAlignment.spaceBetween;
            break;
          case 'around':
            mainAxisAlignment = MainAxisAlignment.spaceAround;
            break;
          case 'evenly':
            mainAxisAlignment = MainAxisAlignment.spaceEvenly;
            break;
          case 'end':
            mainAxisAlignment = MainAxisAlignment.end;
            break;
          default:
            mainAxisAlignment = MainAxisAlignment.start;
        }
      } else if (c.startsWith('items-')) {
        final value = c.substring('items-'.length);
        switch (value) {
          case 'center':
            crossAxisAlignment = CrossAxisAlignment.center;
            break;
          case 'start':
            crossAxisAlignment = CrossAxisAlignment.start;
            break;
          case 'end':
            crossAxisAlignment = CrossAxisAlignment.end;
            break;
          case 'stretch':
            crossAxisAlignment = CrossAxisAlignment.stretch;
            break;
          default:
            crossAxisAlignment = CrossAxisAlignment.center;
        }
      } else if (c.startsWith('gap-')) {
        final value = c.substring('gap-'.length);
        gap = _parseSpacing(value);
      }
    }

    final widgets = toList();
    final spacedChildren = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      spacedChildren.add(widgets[i]);
      if (i < widgets.length - 1 && gap != null) {
        spacedChildren
            .add(isColumn ? SizedBox(height: gap) : SizedBox(width: gap));
      }
    }

    // Build the flex container
    Widget flexWidget = isColumn
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: spacedChildren,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: spacedChildren,
          );

    // Now wrap the flex container with container styling (bg, padding, etc.)
    // We reuse our applyFlutterWind() function, which applies all classes.
    return applyFlutterWind(flexWidget, classes);
  }
}

double? _parseSpacing(String value) {
  const spacingScale = {
    '0': 0.0,
    '1': 4.0,
    '2': 8.0,
    '3': 12.0,
    '4': 16.0,
    '5': 20.0,
    '6': 24.0,
    '8': 32.0,
    '10': 40.0,
    '12': 48.0,
    '16': 64.0,
    '20': 80.0,
    '24': 96.0,
    '32': 128.0,
  };

  if (value.startsWith('[') && value.endsWith(']')) {
    final inner = value.substring(1, value.length - 1);
    return double.tryParse(inner);
  } else {
    return spacingScale[value];
  }
}
