import 'package:flutter/material.dart';
import 'package:flutterwind/src/utils/parser.dart';

class ColorsClass {
  static const Map<String, Color> baseColors = {
    'black': Colors.black,
    'white': Colors.white,
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'gray': Colors.grey,
  };

  static const List<int> shades = [
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900
  ];

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('bg-')) {
      final value = cls.substring(3);
      Color? color = _parseColor(value);
      if (color != null) {
        style.backgroundColor = color;
      }
    } else if (cls.startsWith('text-')) {
      final value = cls.substring(5);
      Color? color = _parseColor(value);
      if (color != null) {
        style.textColor = color;
      }
    }
  }

  static Color? _parseColor(String value) {
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);
      return _parseHexColor(inner);
    } else {
      return _parseTailwindColor(value);
    }
  }

  static Color? _parseHexColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF' + hex;
    int? intColor = int.tryParse(hex, radix: 16);
    return intColor != null ? Color(intColor) : null;
  }

  static Color? _parseTailwindColor(String value) {
    final parts = value.split('-');
    if (parts.length == 2) {
      final base = parts[0];
      final shade = int.tryParse(parts[1]);
      if (baseColors.containsKey(base) &&
          shade != null &&
          shades.contains(shade)) {
        return baseColors[base]!.withOpacity(_shadeToOpacity(shade));
      }
    }
    return baseColors[value]; // fallback to base colors
  }

  static double _shadeToOpacity(int shade) {
    switch (shade) {
      case 50:
        return 0.1;
      case 100:
        return 0.2;
      case 200:
        return 0.3;
      case 300:
        return 0.4;
      case 400:
        return 0.5;
      case 500:
        return 1.0;
      case 600:
        return 0.9;
      case 700:
        return 0.8;
      case 800:
        return 0.7;
      case 900:
        return 0.6;
      default:
        return 1.0;
    }
  }
}
