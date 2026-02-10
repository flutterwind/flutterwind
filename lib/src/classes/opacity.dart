import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

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
      if (value.startsWith('[') && value.endsWith(']')) {
        final inner = value.substring(1, value.length - 1).replaceAll('%', '');
        final parsed = double.tryParse(inner);
        if (parsed != null) {
          style.opacity = parsed > 1.0 ? parsed / 100.0 : parsed;
        }
        return;
      }

      if (TailwindConfig.opacity.containsKey(value)) {
        style.opacity = TailwindConfig.opacity[value];
        return;
      }

      if (opacityScale.containsKey(value)) {
        style.opacity = opacityScale[value];
      }
    }
  }
}
