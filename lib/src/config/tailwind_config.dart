import 'package:flutter/material.dart';
import 'colors.dart';

class TailwindConfig {
  static Map<String, double> screens = {};
  static Map<String, Map<int, Color>> colors = defaultTailwindColors;
  static Map<String, double> spacing = {};
  static Map<String, List<String>> fontFamily = {};
  static Map<String, double> fontSize = {};
  static Map<String, double> borderRadius = {};
  static Map<String, List<BoxShadow>> boxShadow = {};

  static void updateFromYaml(dynamic yamlMap) {
    if (yamlMap == null) return;

    screens = _parseScreens(yamlMap['screens']);
    if (yamlMap['colors'] != null) {
      final userColors = _parseColors(yamlMap['colors']);
      colors = mergeColors(defaultTailwindColors, userColors);
    }
    spacing = _parseSpacing(yamlMap['spacing']);
    fontFamily = _parseFontFamily(yamlMap['fontFamily']);
    fontSize = _parseFontSize(yamlMap['fontSize']);
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
}
