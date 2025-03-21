import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';

class Spacings {
  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('p-')) {
      _setPadding(cls.substring(2), style, all: true);
    } else if (cls.startsWith('px-')) {
      _setPadding(cls.substring(3), style, horizontal: true);
    } else if (cls.startsWith('py-')) {
      _setPadding(cls.substring(3), style, vertical: true);
    } else if (cls.startsWith('ps-')) {
      _setPadding(cls.substring(3), style, start: true);
    } else if (cls.startsWith('pe-')) {
      _setPadding(cls.substring(3), style, end: true);
    } else if (cls.startsWith('m-')) {
      _setMargin(cls.substring(2), style, all: true);
    } else if (cls.startsWith('mx-')) {
      _setMargin(cls.substring(3), style, horizontal: true);
    } else if (cls.startsWith('my-')) {
      _setMargin(cls.substring(3), style, vertical: true);
    } else if (cls.startsWith('ms-')) {
      _setMargin(cls.substring(3), style, start: true);
    } else if (cls.startsWith('me-')) {
      _setMargin(cls.substring(3), style, end: true);
    }
  }

  static void _setPadding(String value, FlutterWindStyle style,
      {bool all = false,
      bool horizontal = false,
      bool vertical = false,
      bool start = false,
      bool end = false}) {
    double? spacing = _parseSpacing(value);
    if (spacing == null) return;

    EdgeInsets currentPadding = style.padding ?? EdgeInsets.zero;
    style.padding = EdgeInsets.only(
      left: start || horizontal || all ? spacing : currentPadding.left,
      right: end || horizontal || all ? spacing : currentPadding.right,
      top: vertical || all ? spacing : currentPadding.top,
      bottom: vertical || all ? spacing : currentPadding.bottom,
    );
  }

  static void _setMargin(String value, FlutterWindStyle style,
      {bool all = false,
      bool horizontal = false,
      bool vertical = false,
      bool start = false,
      bool end = false}) {
    double? spacing = _parseSpacing(value);
    if (spacing == null) return;

    EdgeInsets currentMargin = style.margin ?? EdgeInsets.zero;
    style.margin = EdgeInsets.only(
      left: start || horizontal || all ? spacing : currentMargin.left,
      right: end || horizontal || all ? spacing : currentMargin.right,
      top: vertical || all ? spacing : currentMargin.top,
      bottom: vertical || all ? spacing : currentMargin.bottom,
    );
  }

  static double? _parseSpacing(String value) {
    if (value.startsWith('[') && value.endsWith(']')) {
      return double.tryParse(value.substring(1, value.length - 1));
    }
    return TailwindConfig.spacing[value];
  }
}
