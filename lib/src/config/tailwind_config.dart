import 'package:flutter/material.dart';
import 'colors.dart';
import 'text.dart';
import 'spacing.dart';

class TailwindConfig {
  static Map<String, double> screens = {};
  static Map<String, Map<int, Color>> colors = defaultTailwindColors;
  static Map<String, double> spacing = defaultSpacingScale;
  static Map<String, List<String>> fontFamily = {};
  static Map<String, double> fontSize = defaultFontSize;
  static Map<String, FontWeight> fontWeight = defaultFontWeight;
  static Map<String, double> borderRadius = {};
  static Map<String, List<BoxShadow>> boxShadow = {};

  static void updateFromYaml(dynamic yamlMap) {
    if (yamlMap == null) return;

    screens = _parseScreens(yamlMap['screens']);
    if (yamlMap['colors'] != null) {
      final userColors = _parseColors(yamlMap['colors']);
      colors = mergeColors(defaultTailwindColors, userColors);
    }
    if (yamlMap['spacing'] != null) {
      final userSpacing = _parseFontSize(yamlMap['spacing']);
      spacing = mergeSpacing(defaultSpacingScale, userSpacing);
    }
    fontFamily = _parseFontFamily(yamlMap['fontFamily']);
    if (yamlMap['fontSize'] != null) {
      final userFontSize = _parseFontSize(yamlMap['fontSize']);
      fontSize = mergeFontSize(defaultFontSize, userFontSize);
    }
    if (yamlMap['fontWeight'] != null) {
      final userFontWeight = _parseFontWeight(yamlMap['fontSize']);
      fontWeight = mergeFontWeight(defaultFontWeight, userFontWeight);
    }

    borderRadius = _parseBorderRadius(yamlMap['borderRadius']);
    boxShadow = _parseBoxShadows(yamlMap['boxShadow']); // Renamed method
  }

  static Map<String, double> _parseScreens(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, Map<int, Color>> _parseColors(dynamic data) {
    if (data == null) return {};
    final Map<String, Map<int, Color>> userColors = {};
    (data as Map).forEach((colorName, shades) {
      final Map<int, Color> shadeMap = {};
      (shades as Map).forEach((shade, hex) {
        shadeMap[int.parse(shade.toString())] = _parseHexColor(hex.toString());
      });
      userColors[colorName.toString()] = shadeMap;
    });
    return userColors;
  }

  static Map<String, double> _parseSpacing(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, List<String>> _parseFontFamily(dynamic data) {
    if (data == null) return {};
    return Map<String, List<String>>.from(data.map((key, value) =>
        MapEntry(key, List<String>.from(value.map((v) => v.toString())))));
  }

  static Map<String, double> _parseFontSize(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, FontWeight> _parseFontWeight(dynamic data) {
    if (data == null) return {};
    return Map<String, FontWeight>.from(data.map((key, value) =>
        MapEntry(key, FontWeight.values[(value as num).toInt() ~/ 100 - 1])));
  }

  static Map<String, double> _parseBorderRadius(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, List<BoxShadow>> _parseBoxShadows(dynamic data) {
    // Renamed method
    if (data == null) return {};
    return Map<String, List<BoxShadow>>.from(data.map((key, value) => MapEntry(
        key, List<BoxShadow>.from(value.map((v) => _createBoxShadow(v))))));
  }

  static Color _parseColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static BoxShadow _createBoxShadow(dynamic data) {
    // Renamed method
    return BoxShadow(
      color: _parseColor(data['color']),
      offset: Offset((data['offsetX'] as num).toDouble(),
          (data['offsetY'] as num).toDouble()),
      blurRadius: (data['blurRadius'] as num).toDouble(),
      spreadRadius: (data['spreadRadius'] as num).toDouble(),
    );
  }

  static Color _parseHexColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    return Color(int.parse(hexColor, radix: 16));
  }

  static Map<String, Map<int, Color>> mergeColors(
      Map<String, Map<int, Color>> defaults,
      Map<String, Map<int, Color>> user) {
    final merged = Map<String, Map<int, Color>>.from(defaults);
    user.forEach((key, value) {
      if (merged.containsKey(key)) {
        merged[key] = {...merged[key]!, ...value};
      } else {
        merged[key] = value;
      }
    });
    return merged;
  }

  static Map<String, double> mergeFontSize(
      Map<String, double> defaults, Map<String, double> user) {
    return {...defaults, ...user};
  }

  static Map<String, FontWeight> mergeFontWeight(
      Map<String, FontWeight> defaults, Map<String, FontWeight> user) {
    return {...defaults, ...user}; // Properly merges user-defined values
  }

  static Map<String, double> mergeSpacing(
      Map<String, double> defaults, Map<String, double> user) {
    return {...defaults, ...user}; // Properly merges user-defined values
  }
}
