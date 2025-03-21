import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/inherited/flutterwind_inherited.dart';

extension GridChildExtension on Widget {
  Widget colSpan(int span) {
    return Builder(
      builder: (context) {
        final style = context
            .dependOnInheritedWidgetOfExactType<FlutterWindInherited>()
            ?.style;
        if (style != null) {
          style.colSpans[style.children?.length ?? 0] = span;
        }
        return this;
      },
    );
  }
}
