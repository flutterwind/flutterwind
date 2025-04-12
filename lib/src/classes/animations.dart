import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class AnimationsClass {
  static const Map<String, Duration> durationScale = {
    'duration-75': Duration(milliseconds: 75),
    'duration-100': Duration(milliseconds: 100),
    'duration-200': Duration(milliseconds: 200),
    'duration-300': Duration(milliseconds: 300),
    'duration-500': Duration(milliseconds: 500),
  };

  static const Map<String, Curve> easingScale = {
    'ease-linear': Curves.linear,
    'ease-in': Curves.easeIn,
    'ease-out': Curves.easeOut,
    'ease-in-out': Curves.easeInOut,
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('transition')) {
     style.transitionDuration = const Duration(milliseconds: 300); 
    }

    if (cls.startsWith('duration-')) {
      final match = RegExp(r'duration-(\d+)').firstMatch(cls);
      if (match != null) {
        style.transitionDuration =
            Duration(milliseconds: int.parse(match.group(1)!));
      }
    }
    if (cls.startsWith('ease-')) {
      final match = RegExp(r'ease-(in|out|in-out|linear)').firstMatch(cls);
      if (match!= null) {
        style.transitionCurve = easingScale[match.group(0)!];
      }
    }
  }
}