import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class Spacings {
  static const Map<String, double> spacingScale = {
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

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('p-')) {
      final value = cls.substring(2);
      double? spacing = _parseSpacing(value);
      if (spacing != null) {
        style.padding = EdgeInsets.all(spacing);
      }
    } else if (cls.startsWith('px-')) {
      final value = cls.substring(3);
      double? spacing = _parseSpacing(value);
      if (spacing != null) {
        style.padding = (style.padding ?? EdgeInsets.zero)
            .add(EdgeInsets.symmetric(horizontal: spacing)) as EdgeInsets?;
      }
    } else if (cls.startsWith('py-')) {
      final value = cls.substring(3);
      double? spacing = _parseSpacing(value);
      if (spacing != null) {
        style.padding = (style.padding ?? EdgeInsets.zero)
            .add(EdgeInsets.symmetric(vertical: spacing)) as EdgeInsets?;
      }
    } else if (cls.startsWith('m-')) {
      final value = cls.substring(2);
      double? spacing = _parseSpacing(value);
      if (spacing != null) {
        style.margin = EdgeInsets.all(spacing);
      }
    } else if (cls.startsWith('mx-')) {
      final value = cls.substring(3);
      double? spacing = _parseSpacing(value);
      if (spacing != null) {
        style.margin = (style.margin ?? EdgeInsets.zero)
            .add(EdgeInsets.symmetric(horizontal: spacing)) as EdgeInsets?;
      }
    } else if (cls.startsWith('my-')) {
      final value = cls.substring(3);
      double? spacing = _parseSpacing(value);
      if (spacing != null) {
        style.margin = (style.margin ?? EdgeInsets.zero)
            .add(EdgeInsets.symmetric(vertical: spacing)) as EdgeInsets?;
      }
    }
  }

  static double? _parseSpacing(String value) {
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);
      return double.tryParse(inner);
    } else {
      return spacingScale[value];
    }
  }
}
