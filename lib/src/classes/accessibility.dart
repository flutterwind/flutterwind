import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutter/material.dart';

class AccessibilityClass {
  // Focus management presets
  static const Map<String, bool> focusableValues = {
    'focusable': true,
    'not-focusable': false,
  };

  // Focus order presets
  static const Map<String, int> focusOrderValues = {
    'focus-first': 1,
    'focus-last': 999,
  };

  static void apply(String className, FlutterWindStyle style) {
    // Note: outline-none in Tailwind CSS is VISUAL ONLY (outline: none;)
    // It does NOT prevent focus - the element remains fully interactive
    // Therefore we should NOT set focusable=false for outline-none
    if (className == 'outline-none') {
      // Visual style only - could be used for custom rendering if needed
      // For now, we just ignore it (no functional impact)
      return;
    } else if (className == 'outline') {
      // Default outline style - also visual only
      return;
    } else if (className == 'sr-only') {
      style.screenReaderOnly = true;
      style.semanticsLabel ??= '';
    } else if (className == 'aria-live') {
      style.liveRegion = true;
    } else if (className.startsWith('focus-order-')) {
      final order = int.tryParse(className.substring('focus-order-'.length));
      if (order != null) {
        style.focusOrder = order;
      }
    } else if (focusableValues.containsKey(className)) {
      _applyFocusable(className, style);
    } else if (focusOrderValues.containsKey(className)) {
      _applyFocusOrder(className, style);
    }
  }

  static void _applyFocusable(String cls, FlutterWindStyle style) {
    if (focusableValues.containsKey(cls)) {
      style.focusable = focusableValues[cls];
    }
  }

  static void _applyFocusOrder(String cls, FlutterWindStyle style) {
    if (focusOrderValues.containsKey(cls)) {
      style.focusOrder = focusOrderValues[cls];
    }
  }
}
