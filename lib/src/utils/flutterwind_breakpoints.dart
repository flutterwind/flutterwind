import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class _SplitVariantResult {
  final List<String> variants;
  final String utility;

  const _SplitVariantResult({
    required this.variants,
    required this.utility,
  });
}

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

    final parsed = _splitVariantChain(cls);
    final utility = parsed.utility;
    final variants = parsed.variants;

    var allResponsiveMatch = true;
    for (final variant in variants) {
      if (TailwindConfig.screens.containsKey(variant) &&
          !activeBreakpoints.contains(variant)) {
        allResponsiveMatch = false;
        break;
      }
    }

    if (allResponsiveMatch) {
      resolvedClasses.add(utility);
    }
  }
  return resolvedClasses;
}

_SplitVariantResult _splitVariantChain(String cls) {
  final parts = <String>[];
  final buffer = StringBuffer();
  var bracketDepth = 0;
  var parenDepth = 0;

  for (final rune in cls.runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '[') {
      bracketDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ']') {
      if (bracketDepth > 0) bracketDepth--;
      buffer.write(ch);
      continue;
    }
    if (ch == '(') {
      parenDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ')') {
      if (parenDepth > 0) parenDepth--;
      buffer.write(ch);
      continue;
    }
    if (ch == ':' && bracketDepth == 0 && parenDepth == 0) {
      parts.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(ch);
  }
  parts.add(buffer.toString());
  if (parts.length <= 1) {
    return _SplitVariantResult(variants: const <String>[], utility: cls);
  }
  return _SplitVariantResult(
    variants: parts.sublist(0, parts.length - 1),
    utility: parts.last,
  );
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