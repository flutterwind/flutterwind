import 'package:flutter/material.dart';
import 'package:flutterwind/src/utils/parser.dart';

/// Extension on Widget to support Tailwind‑like classes.
/// Example:
///   Text("Hello").cls("text-lg font-bold bg-[#ff0000] p-2")
extension FlutterWindExtension on Widget {
  Widget className(String classString) {
    final classes = classString.split(RegExp(r'\s+'));
    return applyFlutterWind(this, classes);
  }
}
