import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';

class TypographyClass {
  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('text-')) {
      final value = cls.substring(5);
      double? size = _parseTextSize(value);
      if (size != null) {
        style.textSize = size;
      }
    } else if (cls.startsWith('font-')) {
      final value = cls.substring(5);
      FontWeight? weight = _parseFontWeight(value);
      if (weight != null) {
        style.fontWeight = weight;
      }
    }
  }

  static double? _parseTextSize(String value) {
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);
      return double.tryParse(inner);
    } else {
      return TailwindConfig.fontSize[value];
    }
  }

  static FontWeight? _parseFontWeight(String value) {
    if (TailwindConfig.fontWeight.containsKey(value)) {
      return TailwindConfig.fontWeight[value];
    }
    return null;
  }
}
