import 'package:flutterwind_core/src/utils/parser.dart';

class AspectRatioClass {
  // Common aspect ratios
  static const Map<String, double> aspectRatioScale = {
    'square': 1.0, // 1:1
    'video': 16 / 9, // 16:9
    '4/3': 4 / 3, // 4:3
    '16/9': 16 / 9, // 16:9
    '21/9': 21 / 9, // 21:9 (ultrawide)
    '1/1': 1.0, // 1:1 (square)
    '2/1': 2.0, // 2:1
    '1/2': 0.5, // 1:2
    '3/2': 1.5, // 3:2
    '2/3': 2 / 3, // 2:3
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('aspect-')) {
      final value = cls.substring(7);
      _applyAspectRatio(value, style);
    }
  }

  static void _applyAspectRatio(String value, FlutterWindStyle style) {
    // Handle predefined aspect ratios
    if (aspectRatioScale.containsKey(value)) {
      style.aspectRatio = aspectRatioScale[value];
      return;
    }

    // Handle aspect-auto
    if (value == 'auto') {
      style.aspectRatio = null;
      return;
    }

    // Handle arbitrary values: aspect-[16/9]
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);

      // Handle fractions like 16/9
      if (inner.contains('/')) {
        final parts = inner.split('/');
        if (parts.length == 2) {
          double? numerator = double.tryParse(parts[0]);
          double? denominator = double.tryParse(parts[1]);
          if (numerator != null && denominator != null && denominator != 0) {
            style.aspectRatio = numerator / denominator;
            return;
          }
        }
      }

      // Handle direct decimal values
      double? ratio = double.tryParse(inner);
      if (ratio != null) {
        style.aspectRatio = ratio;
        return;
      }
    }

    // Handle direct ratio format: aspect-16/9
    if (value.contains('/')) {
      final parts = value.split('/');
      if (parts.length == 2) {
        double? numerator = double.tryParse(parts[0]);
        double? denominator = double.tryParse(parts[1]);
        if (numerator != null && denominator != null && denominator != 0) {
          style.aspectRatio = numerator / denominator;
        }
      }
    }
  }
}
