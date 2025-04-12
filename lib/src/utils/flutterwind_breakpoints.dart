import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

List<String> resolveFlutterWindResponsiveClasses(
  List<String> classes,
  BuildContext context,
) {
  final screenWidth = MediaQuery.of(context).size.width;
  final activeBreakpoints = _getMatchedBreakpoint(screenWidth);
  final resolvedClasses = <String>[];

  for (final cls in classes) {
    if (!cls.contains(':')) {
      resolvedClasses.add(cls);
      continue;
    }

    final parts = cls.split(':');
    final breakpoint = parts[0];
    final style = parts[1];

    if (activeBreakpoints.contains(breakpoint)) {
      resolvedClasses.add(style);
    }
  }
  return resolvedClasses;
}

Set<String> _getMatchedBreakpoint(double width) {
  final breakpoints = TailwindConfig.screens.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));
  final active = <String>{};

  for (final bp in breakpoints) {
    if (width >= bp.value) {
      active.add(bp.key);
    }
  }
  return active;
}

bool isResponsiveClass(String cls) {
	return RegExp(r'^(sm|md|lg|xl|2xl):').hasMatch(cls);
}