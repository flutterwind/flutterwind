import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

/// Extension on Widget to support Tailwind‑like classes.
/// Example:
///   Text("Hello").className("text-lg font-bold bg-[#ff0000] p-2")
extension FlutterWindExtension on Widget {
  Widget className(String classString) {
    return Builder(
      builder: (context) {
        // This will rebuild whenever MediaQuery changes (screen resize)
        MediaQuery.of(context);

        final classes = classString.split(RegExp(r'\s+'));
        return applyFlutterWind(this, classes, context);
      },
    );
  }
}
