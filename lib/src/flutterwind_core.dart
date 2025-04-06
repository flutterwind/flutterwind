import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

/// Extension on Widget to support Tailwind‑like classes.
/// Example:
///   Text("Hello").className("text-lg font-bold bg-[#ff0000] p-2")
extension FlutterWindExtension on Widget {
  Widget className(String classString) {
    final classes = classString.split(RegExp(r'\s+'));
    print("classes ::: $classes");
    return applyFlutterWind(this, classes);
  }
}
