import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';

class PositionClass {
  static void apply(String cls, FlutterWindStyle style) {
    // Handle position types
    if (cls == 'absolute') {
      style.position = PositionType.absolute;
    } else if (cls == 'relative') {
      style.position = PositionType.relative;
    } else if (cls == 'fixed') {
      style.position = PositionType.fixed;
    } else if (cls == 'sticky') {
      style.position = PositionType.sticky;
    }
    
    // Handle inset properties
    if (cls.startsWith('inset-')) {
      final value = cls.substring(6);
      _applyInset(value, style);
    } else if (cls.startsWith('top-')) {
      final value = cls.substring(4);
      _applyInsetValue(value, style, InsetDirection.top);
    } else if (cls.startsWith('right-')) {
      final value = cls.substring(6);
      _applyInsetValue(value, style, InsetDirection.right);
    } else if (cls.startsWith('bottom-')) {
      final value = cls.substring(7);
      _applyInsetValue(value, style, InsetDirection.bottom);
    } else if (cls.startsWith('left-')) {
      final value = cls.substring(5);
      _applyInsetValue(value, style, InsetDirection.left);
    }
  }

  static void _applyInset(String value, FlutterWindStyle style) {
    double? insetValue = _parseInsetValue(value);
    if (insetValue != null) {
      style.insetTop = insetValue;
      style.insetRight = insetValue;
      style.insetBottom = insetValue;
      style.insetLeft = insetValue;
    }
  }

  static void _applyInsetValue(String value, FlutterWindStyle style, InsetDirection direction) {
    double? insetValue = _parseInsetValue(value);
    if (insetValue != null) {
      switch (direction) {
        case InsetDirection.top:
          style.insetTop = insetValue;
          break;
        case InsetDirection.right:
          style.insetRight = insetValue;
          break;
        case InsetDirection.bottom:
          style.insetBottom = insetValue;
          break;
        case InsetDirection.left:
          style.insetLeft = insetValue;
          break;
      }
    }
  }

  static double? _parseInsetValue(String value) {
    // Handle arbitrary values: inset-[10]
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);
      return double.tryParse(inner);
    }
    
    // Handle predefined spacing values
    if (TailwindConfig.spacing.containsKey(value)) {
      return TailwindConfig.spacing[value];
    }
    
    // Handle auto value
    if (value == 'auto') {
      return null; // Special case for auto
    }
    
    // Handle negative values
    if (value.startsWith('-')) {
      final positiveValue = value.substring(1);
      if (TailwindConfig.spacing.containsKey(positiveValue)) {
        return -TailwindConfig.spacing[positiveValue]!;
      }
    }
    
    return null;
  }
}

enum PositionType {
  relative,
  absolute,
  fixed,
  sticky,
}

enum InsetDirection {
  top,
  right,
  bottom,
  left,
}