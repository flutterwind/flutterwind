import 'package:flutter/material.dart';
import 'package:flutterwind/src/utils/parser.dart';

class TypographyClass {
  static const Map<String, double> textSizes = {
    'xs': 10.0,
    'sm': 12.0,
    'base': 14.0,
    'lg': 16.0,
    'xl': 18.0,
    '2xl': 20.0,
    '3xl': 24.0,
    '4xl': 30.0,
  };

  static const Map<String, FontWeight> fontWeights = {
    'thin': FontWeight.w100,
    'light': FontWeight.w300,
    'normal': FontWeight.w400,
    'medium': FontWeight.w500,
    'semibold': FontWeight.w600,
    'bold': FontWeight.w700,
    'extrabold': FontWeight.w800,
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('text-')) {
      final value = cls.substring(5);
      double? size = _parseTextSize(value);
      if (size != null) {
        style.textSize = size;
      }
    } else if (cls.startsWith('font-')) {
      final value = cls.substring(5);
      if (fontWeights.containsKey(value)) {
        style.fontWeight = fontWeights[value];
      }
    }
  }

  static double? _parseTextSize(String value) {
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);
      return double.tryParse(inner);
    } else {
      return textSizes[value];
    }
  }
}
