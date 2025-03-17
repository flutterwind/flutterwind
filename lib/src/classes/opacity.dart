import 'package:flutterwind/src/utils/parser.dart';

class OpacityClass {
  static const Map<String, double> opacityScale = {
    '0': 0.0,
    '25': 0.25,
    '50': 0.5,
    '75': 0.75,
    '100': 1.0,
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('opacity-')) {
      final value = cls.substring(8);
      if (opacityScale.containsKey(value)) {
        style.opacity = opacityScale[value];
      }
    }
  }
}
