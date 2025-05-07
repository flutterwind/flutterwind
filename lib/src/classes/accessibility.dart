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
    if (className == 'focus:outline-none') {
      style.focusable = false;
    } else if (className == 'focus:outline') {
      style.focusable = true;
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
