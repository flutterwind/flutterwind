import 'package:flutter/material.dart';

class TailwindConfig {
  static Map<String, double> screens = {};
  static Map<String, Color> colors = {};
  static Map<String, double> spacing = {};
  static Map<String, List<String>> fontFamily = {};
  static Map<String, double> fontSize = {};
  static Map<String, double> borderRadius = {};
  static Map<String, List<BoxShadow>> boxShadow = {};

  static void updateFromYaml(dynamic yamlMap) {
    if (yamlMap == null) return;

    screens = _parseScreens(yamlMap['screens']);
    colors = _parseColors(yamlMap['colors']);
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

  static Map<String, Color> _parseColors(dynamic data) {
    if (data == null) return {};
    return Map<String, Color>.from(
        data.map((key, value) => MapEntry(key, _parseColor(value))));
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
}
