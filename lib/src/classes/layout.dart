import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

/// GridItemWrapper tracks column span information for grid items
class GridItemWrapper extends StatelessWidget {
  final Widget child;
  final int colSpan;

  const GridItemWrapper({
    super.key,
    required this.child,
    this.colSpan = 1,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Extension to add colSpan to any widget for grid layouts
extension ColSpanExtension on Widget {
  Widget colSpan(int span) {
    return GridItemWrapper(
      colSpan: span,
      child: this,
    );
  }
}

extension FlutterWindLayoutExtension on Iterable<Widget> {
  Widget className(String classString) {
    final classRegex = RegExp(r'(?:\w+:[^\s]+|\w+-\[[^\]]*\]|\w+[\w-]*|\[[^\]]*\])');
    final classes =
        classRegex.allMatches(classString).map((m) => m.group(0)!).toList();
        
    // Check if this is a grid layout
    if (classes.contains('grid')) {
      return _buildGridLayout(classes);
    }

    // Otherwise handle as flex layout
    return _buildFlexLayout(classes);
  }

  Widget _buildFlexLayout(List<String> classes) {
    // Process flex-related classes
    bool isColumn = classes.contains('flex-col');

    // If flex is specified without direction, default to row
    if (classes.contains('flex') &&
        !isColumn &&
        !classes.contains('flex-row')) {
      isColumn = false;
    }

    // Parse alignment options
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    CrossAxisAlignment crossAxisAlignment =
        isColumn ? CrossAxisAlignment.stretch : CrossAxisAlignment.center;
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
          case 'baseline':
            crossAxisAlignment = CrossAxisAlignment.baseline;
            break;
          default:
            crossAxisAlignment = isColumn
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.center;
        }
      } else if (c.startsWith('gap-')) {
        final value = c.substring('gap-'.length);
        gap = _parseSpacing(value);
      }
    }

    final widgets = toList();
    final spacedChildren = <Widget>[];

    // Add widgets with appropriate spacing
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
            mainAxisSize: MainAxisSize.min,
            children: spacedChildren,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: spacedChildren,
          );

    // Apply other classes for styling (background, padding, etc.)
    return applyFlutterWind(flexWidget, classes);
  }

  /// Builds a grid layout
  Widget _buildGridLayout(List<String> classes) {
    // Parse grid properties
    int gridColumns = 2; // Default 2 columns
    double gridGap = 8.0; // Default gap

    for (final cls in classes) {
      if (cls.startsWith('grid-cols-')) {
        final match = RegExp(r'grid-cols-(\d+)').firstMatch(cls);
        if (match != null) {
          gridColumns = int.parse(match.group(1)!);
        }
      } else if (cls.startsWith('gap-')) {
        final value = cls.substring('gap-'.length);
        gridGap = _parseSpacing(value) ?? 8.0;
      }
    }

    // Process widgets to handle column spans
    List<Widget> rows = [];
    List<Widget> currentRow = [];
    int currentColSpan = 0;
    final widgets = toList();

    for (int i = 0; i < widgets.length; i++) {
      final child = widgets[i];

      // Get column span if specified
      int span = 1;
      Widget actualChild = child;

      if (child is GridItemWrapper) {
        span = child.colSpan.clamp(1, gridColumns);
        actualChild = child.child;
      }

      // Check if we need to start a new row
      if (currentColSpan + span > gridColumns) {
        // Fill remaining space in current row if needed
        if (currentColSpan < gridColumns) {
          currentRow.add(
            Expanded(
              flex: gridColumns - currentColSpan,
              child: Container(), // Empty spacer
            ),
          );
        }

        // Add current row
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: currentRow,
          ),
        );

        // Start a new row
        currentRow = [];
        currentColSpan = 0;
      }

      // Add child to current row with appropriate span
      currentRow.add(
        Expanded(
          flex: span,
          child: Padding(
            padding: EdgeInsets.all(gridGap / 2),
            child: actualChild,
          ),
        ),
      );

      currentColSpan += span;

      // If we've filled a row, add it to rows
      if (currentColSpan >= gridColumns) {
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: currentRow,
          ),
        );

        // Start a new row
        currentRow = [];
        currentColSpan = 0;
      }
    }

    // Add any remaining children as a final row
    if (currentRow.isNotEmpty) {
      // Fill remaining space if needed
      if (currentColSpan < gridColumns) {
        currentRow.add(
          Expanded(
            flex: gridColumns - currentColSpan,
            child: Container(), // Empty spacer
          ),
        );
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: currentRow,
        ),
      );
    }

    // Create a column of rows for the grid
    final gridWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: rows.map((row) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: gridGap / 2),
          child: row,
        );
      }).toList(),
    );

    // Apply other styling (background, padding, etc.)
    return applyFlutterWind(gridWidget, classes);
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
