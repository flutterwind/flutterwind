import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class ColorsClass {
  static const Map<String, Color> baseColors = {
    'black': Colors.black,
    'white': Colors.white,
    'transparent': Colors.transparent,
    'gray': Colors.grey,
    'red': Colors.red,
    'orange': Colors.orange,
    'amber': Colors.amber,
    'yellow': Colors.yellow,
    'lime': Colors.lime,
    'green': Colors.green,
    'teal': Colors.teal,
    'cyan': Colors.cyan,
    'blue': Colors.blue,
    'indigo': Colors.indigo,
    'violet': Colors.purple,
    'purple': Colors.purple,
    'pink': Colors.pink,
    'brown': Colors.brown,
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
    900,
    950
  ];

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('bg-')) {
      final value = cls.substring(3);
      if (value.startsWith('gradient-to-')) {
        _applyGradient(value.substring(11), style);
      } else {
        Color? color = parseColor(value); // Updated to public method
        if (color != null) {
          style.backgroundColor = color;
        }
      }
    } else if (cls.startsWith('text-')) {
      final value = cls.substring(5);
      Color? color = parseColor(value); // Updated to public method
      if (color != null) {
        style.textColor = color;
      }
    } else if (cls.startsWith('from-')) {
      _addGradientColor(cls.substring(5), style, isFrom: true);
    } else if (cls.startsWith('via-')) {
      _addGradientColor(cls.substring(4), style, isVia: true);
    } else if (cls.startsWith('to-')) {
      _addGradientColor(cls.substring(3), style, isTo: true);
    }
  }

  static void _applyGradient(String direction, FlutterWindStyle style) {
    final colors = <Color>[];
    final stops = <double>[];

    if (style.gradientColors != null) {
      colors.addAll(style.gradientColors!);
    }
    if (style.gradientStops != null) {
      stops.addAll(style.gradientStops!);
    }

    if (colors.isEmpty) return;

    Alignment begin;
    Alignment end;

    switch (direction) {
      case 'r':
        begin = Alignment.centerLeft;
        end = Alignment.centerRight;
        break;
      case 'l':
        begin = Alignment.centerRight;
        end = Alignment.centerLeft;
        break;
      case 't':
        begin = Alignment.bottomCenter;
        end = Alignment.topCenter;
        break;
      case 'b':
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
        break;
      case 'tr':
        begin = Alignment.bottomLeft;
        end = Alignment.topRight;
        break;
      case 'tl':
        begin = Alignment.bottomRight;
        end = Alignment.topLeft;
        break;
      case 'br':
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
        break;
      case 'bl':
        begin = Alignment.topRight;
        end = Alignment.bottomLeft;
        break;
      default:
        begin = Alignment.centerLeft;
        end = Alignment.centerRight;
    }

    style.gradient = LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
      stops: stops.isNotEmpty ? stops : null,
    );
  }

  static void _addGradientColor(String value, FlutterWindStyle style,
      {bool isFrom = false, bool isVia = false, bool isTo = false}) {
    Color? color = parseColor(value); // Updated to public method
    if (color == null) return;

    style.gradientColors ??= [];
    style.gradientStops ??= [];

    if (isFrom) {
      style.gradientColors!.insert(0, color);
      style.gradientStops!.insert(0, 0.0);
    } else if (isVia) {
      final middleIndex = style.gradientColors!.length ~/ 2;
      style.gradientColors!.insert(middleIndex, color);
      style.gradientStops!.insert(middleIndex, 0.5);
    } else if (isTo) {
      style.gradientColors!.add(color);
      style.gradientStops!.add(1.0);
    }
  }

  static Color? parseColor(String value) {
    // Check for opacity modifier
    String colorValue = value;
    double? opacity;

    if (value.contains('/') && !value.contains('[')) {
      final parts = value.split('/');
      if (parts.length == 2) {
        colorValue = parts[0];
        final opacityValue = int.tryParse(parts[1]);
        if (opacityValue != null) {
          opacity = opacityValue / 100.0;
        }
      }
    }

    Color? color;
    if (colorValue.startsWith('[') && colorValue.endsWith(']')) {
      final inner = colorValue.substring(1, colorValue.length - 1);
      color = _parseHexColor(inner);
    } else {
      color = _parseTailwindColor(colorValue);
    }

    if (color != null && opacity != null) {
      return color.withValues(alpha: opacity);
    }
    return color;
  }

  static Color? _parseHexColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    int? intColor = int.tryParse(hex, radix: 16);
    return intColor != null ? Color(intColor) : null;
  }

  static Color? _parseTailwindColor(String value) {
    return TailwindConfig.resolveColorToken(value) ?? baseColors[value];
  }

  static double _shadeToOpacity(int shade) {
    switch (shade) {
      case 50:
        return 0.05;
      case 100:
        return 0.1;
      case 200:
        return 0.2;
      case 300:
        return 0.3;
      case 400:
        return 0.4;
      case 500:
        return 0.5;
      case 600:
        return 0.6;
      case 700:
        return 0.7;
      case 800:
        return 0.8;
      case 900:
        return 0.9;
      case 950:
        return 0.95;
      default:
        return 1.0;
    }
  }
}
