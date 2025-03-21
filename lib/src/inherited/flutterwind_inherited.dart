import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class FlutterWindInherited extends InheritedWidget {
  final FlutterWindStyle style;

  const FlutterWindInherited({
    super.key,
    required this.style,
    required super.child,
  });

  static FlutterWindInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FlutterWindInherited>();
  }

  @override
  bool updateShouldNotify(FlutterWindInherited oldWidget) {
    return style != oldWidget.style;
  }
}
