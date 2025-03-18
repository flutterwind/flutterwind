import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class ShadowsClass {
  static const Map<String, List<BoxShadow>> shadowScale = {
    'shadow-2xs': [
      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 0.5))
    ],
    'shadow-xs': [
      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1))
    ],
    'shadow-sm': [
      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
    ],
    'shadow-md': [
      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))
    ],
    'shadow-lg': [
      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 6))
    ],
    'shadow-xl': [
      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 8))
    ],
    'shadow-2xl': [
      BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 10))
    ],
    'shadow-none': [],
  };

  // Inset shadows (placeholders; true inset effect requires custom painting)
  static const Map<String, List<BoxShadow>> insetShadowScale = {
    'inset-shadow-2xs': [
      BoxShadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 1)
    ],
    'inset-shadow-xs': [
      BoxShadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 2)
    ],
    'inset-shadow-sm': [
      BoxShadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 3),
      BoxShadow(
          color: Colors.black,
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: -1),
    ],
    // Add more as needed…
    'inset-shadow-none': [],
  };

  // Ring shadow parsing – basic implementation: if class is ring-<number> or ring-[value]
  static BoxShadow? ringFor(String cls) {
    final regex = RegExp(r'^ring-(\d+)$');
    final match = regex.firstMatch(cls);
    if (match != null) {
      double ringWidth = double.parse(match.group(1)!);
      return BoxShadow(
        color: Colors
            .black, // default ring color (can be overridden by ring-color classes)
        offset: Offset.zero,
        blurRadius: 0,
        spreadRadius: ringWidth,
      );
    }
    if (cls.startsWith('ring-[') && cls.endsWith(']')) {
      final inner = cls.substring(6, cls.length - 1).replaceAll('px', '');
      double? ringWidth = double.tryParse(inner);
      if (ringWidth != null) {
        return BoxShadow(
          color: Colors.black,
          offset: Offset.zero,
          blurRadius: 0,
          spreadRadius: ringWidth,
        );
      }
    }
    return null;
  }

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('shadow-[') && cls.endsWith(']')) {
      // Parse arbitrary outer shadow value
      // (This example simply uses a default shadow for arbitrary input.)
      style.boxShadows = [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(0, 10),
          blurRadius: 15,
          spreadRadius: 0,
        )
      ];
    } else if (cls.startsWith('shadow-(') && cls.endsWith(')')) {
      // Custom property – not implemented in this example.
    } else if (shadowScale.containsKey(cls)) {
      // Apply outer shadow presets.
      style.boxShadows = shadowScale[cls];
    } else if (cls.startsWith('inset-shadow-')) {
      // Apply inset shadow presets.
      if (insetShadowScale.containsKey(cls)) {
        style.insetBoxShadows = insetShadowScale[cls];
      }
    } else if (cls.startsWith('ring-')) {
      // Handle ring classes.
      BoxShadow? ring = ringFor(cls);
      if (ring != null) {
        style.ringShadow = ring;
        // Optionally, set a default ring color if not already set.
        style.ringColor ??= Colors.black;
        style.ringWidth = ring.spreadRadius;
      } else if (cls.startsWith('ring-') && cls.contains('red') ||
          cls.contains('blue') ||
          cls.contains('green') ||
          cls.contains('black') ||
          cls.contains('white')) {
        // For ring color classes such as "ring-red-500", you would map these to a color.
        // For brevity, here’s a basic example:
        if (cls.startsWith('ring-red-')) {
          style.ringColor = Colors.red;
        } else if (cls.startsWith('ring-blue-')) {
          style.ringColor = Colors.blue;
        } else if (cls.startsWith('ring-green-')) {
          style.ringColor = Colors.green;
        } else if (cls == 'ring-black') {
          style.ringColor = Colors.black;
        } else if (cls == 'ring-white') {
          style.ringColor = Colors.white;
        }
      }
    }
  }
}
