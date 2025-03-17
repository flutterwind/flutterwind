import 'package:flutter/material.dart';
import 'package:flutterwind/src/utils/parser.dart';

class BordersClass {
  static const Map<String, BorderRadius> borderRadiusScale = {
    'none': BorderRadius.zero,
    'sm': BorderRadius.all(Radius.circular(2)),
    '': BorderRadius.all(Radius.circular(4)),
    'md': BorderRadius.all(Radius.circular(6)),
    'lg': BorderRadius.all(Radius.circular(8)),
    'full': BorderRadius.all(Radius.circular(9999)),
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('rounded')) {
      String value = cls.substring('rounded'.length);
      if (value.startsWith('-')) value = value.substring(1);
      if (value.startsWith('[') && value.endsWith(']')) {
        final inner = value.substring(1, value.length - 1);
        double? radius = double.tryParse(inner);
        if (radius != null) {
          style.borderRadius = BorderRadius.all(Radius.circular(radius));
        }
      } else if (value.isEmpty) {
        style.borderRadius = BorderRadius.all(Radius.circular(4));
      } else {
        if (borderRadiusScale.containsKey(value)) {
          style.borderRadius = borderRadiusScale[value];
        }
      }
    }
  }
}
