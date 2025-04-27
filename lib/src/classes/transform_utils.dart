import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

/// TransformUtils class implements Tailwind CSS transform functionality
/// including scale, rotate, translate, skew, and transform origin.
class TransformUtils {
  // Scale values (as multipliers)
  static const Map<String, double> scaleValues = {
    '0': 0.0,
    '50': 0.5,
    '75': 0.75,
    '90': 0.9,
    '95': 0.95,
    '100': 1.0,
    '105': 1.05,
    '110': 1.1,
    '125': 1.25,
    '150': 1.5,
    '200': 2.0,
  };

  // Rotation values (in degrees)
  static const Map<String, double> rotateValues = {
    '0': 0.0,
    '1': 1.0,
    '2': 2.0,
    '3': 3.0,
    '6': 6.0,
    '12': 12.0,
    '45': 45.0,
    '90': 90.0,
    '180': 180.0,
    '-1': -1.0,
    '-2': -2.0,
    '-3': -3.0,
    '-6': -6.0,
    '-12': -12.0,
    '-45': -45.0,
    '-90': -90.0,
    '-180': -180.0,
  };

  // Transform origin values
  static const Map<String, Alignment> originValues = {
    'center': Alignment.center,
    'top': Alignment.topCenter,
    'top-right': Alignment.topRight,
    'right': Alignment.centerRight,
    'bottom-right': Alignment.bottomRight,
    'bottom': Alignment.bottomCenter,
    'bottom-left': Alignment.bottomLeft,
    'left': Alignment.centerLeft,
    'top-left': Alignment.topLeft,
  };

  /// Apply transform classes to the FlutterWindStyle
  static void apply(String cls, FlutterWindStyle style) {
    // Scale transforms
    if (cls.startsWith('scale-')) {
      final value = cls.substring(6);
      _applyScale(value, style);
    }
    else if (cls.startsWith('scale-x-')) {
      final value = cls.substring(8);
      _applyScaleX(value, style);
    }
    else if (cls.startsWith('scale-y-')) {
      final value = cls.substring(8);
      _applyScaleY(value, style);
    }
    // Rotate transforms
    else if (cls.startsWith('rotate-')) {
      final value = cls.substring(7);
      _applyRotate(value, style);
    }
    // Translate transforms
    else if (cls.startsWith('translate-x-')) {
      final value = cls.substring(12);
      _applyTranslateX(value, style);
    }
    else if (cls.startsWith('translate-y-')) {
      final value = cls.substring(12);
      _applyTranslateY(value, style);
    }
    // Skew transforms
    else if (cls.startsWith('skew-x-')) {
      final value = cls.substring(7);
      _applySkewX(value, style);
    }
    else if (cls.startsWith('skew-y-')) {
      final value = cls.substring(7);
      _applySkewY(value, style);
    }
    // Transform origin
    else if (cls.startsWith('origin-')) {
      final value = cls.substring(7);
      _applyOrigin(value, style);
    }
  }

  /// Apply scale transform
  static void _applyScale(String value, FlutterWindStyle style) {
    double scale = 1.0;
    
    if (scaleValues.containsKey(value)) {
      scale = scaleValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: scale-[1.25]
      final inner = value.substring(1, value.length - 1);
      scale = double.tryParse(inner) ?? 1.0;
    }
    
    style.transform ??= Matrix4.identity();
    style.transform!.scale(scale, scale);
  }

  /// Apply scale X transform
  static void _applyScaleX(String value, FlutterWindStyle style) {
    double scale = 1.0;
    
    if (scaleValues.containsKey(value)) {
      scale = scaleValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: scale-x-[1.25]
      final inner = value.substring(1, value.length - 1);
      scale = double.tryParse(inner) ?? 1.0;
    }
    
    style.transform ??= Matrix4.identity();
    style.transform!.scale(scale, 1.0);
  }

  /// Apply scale Y transform
  static void _applyScaleY(String value, FlutterWindStyle style) {
    double scale = 1.0;
    
    if (scaleValues.containsKey(value)) {
      scale = scaleValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: scale-y-[1.25]
      final inner = value.substring(1, value.length - 1);
      scale = double.tryParse(inner) ?? 1.0;
    }
    
    style.transform ??= Matrix4.identity();
    style.transform!.scale(1.0, scale);
  }

  /// Apply rotation transform
  static void _applyRotate(String value, FlutterWindStyle style) {
    double degrees = 0.0;
    
    if (rotateValues.containsKey(value)) {
      degrees = rotateValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: rotate-[45deg]
      final inner = value.substring(1, value.length - 1).replaceAll('deg', '');
      degrees = double.tryParse(inner) ?? 0.0;
    }
    
    // Convert degrees to radians
    final radians = degrees * (math.pi / 180.0);
    
    style.transform ??= Matrix4.identity();
    style.transform!.rotateZ(radians);
  }

  /// Apply translate X transform
  static void _applyTranslateX(String value, FlutterWindStyle style) {
    double pixels = 0.0;
    
    if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: translate-x-[10px]
      final inner = value.substring(1, value.length - 1).replaceAll('px', '');
      pixels = double.tryParse(inner) ?? 0.0;
    } else {
      // Handle percentage values like translate-x-1/2 (50%)
      if (value.contains('/')) {
        final parts = value.split('/');
        if (parts.length == 2) {
          final numerator = double.tryParse(parts[0]) ?? 0;
          final denominator = double.tryParse(parts[1]) ?? 1;
          if (denominator != 0) {
            // Store as percentage for later application
            style.translateXFactor = numerator / denominator;
            return;
          }
        }
      } else {
        // Handle numeric values (assumed to be in pixels)
        pixels = double.tryParse(value) ?? 0.0;
      }
    }
    
    style.transform ??= Matrix4.identity();
    style.transform!.translate(pixels, 0.0);
  }

  /// Apply translate Y transform
  static void _applyTranslateY(String value, FlutterWindStyle style) {
    double pixels = 0.0;
    
    if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: translate-y-[10px]
      final inner = value.substring(1, value.length - 1).replaceAll('px', '');
      pixels = double.tryParse(inner) ?? 0.0;
    } else {
      // Handle percentage values like translate-y-1/2 (50%)
      if (value.contains('/')) {
        final parts = value.split('/');
        if (parts.length == 2) {
          final numerator = double.tryParse(parts[0]) ?? 0;
          final denominator = double.tryParse(parts[1]) ?? 1;
          if (denominator != 0) {
            // Store as percentage for later application
            style.translateYFactor = numerator / denominator;
            return;
          }
        }
      } else {
        // Handle numeric values (assumed to be in pixels)
        pixels = double.tryParse(value) ?? 0.0;
      }
    }
    
    style.transform ??= Matrix4.identity();
    style.transform!.translate(0.0, pixels);
  }

  /// Apply skew X transform
  static void _applySkewX(String value, FlutterWindStyle style) {
    double degrees = 0.0;
    
    if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: skew-x-[10deg]
      final inner = value.substring(1, value.length - 1).replaceAll('deg', '');
      degrees = double.tryParse(inner) ?? 0.0;
    } else {
      // Handle numeric values (assumed to be in degrees)
      degrees = double.tryParse(value) ?? 0.0;
    }
    
    // Convert degrees to radians
    final radians = degrees * (math.pi / 180.0);
    
    style.transform ??= Matrix4.identity();
    // Apply skew X (this is a bit tricky in Matrix4)
    style.transform!.setEntry(1, 0, math.tan(radians));
  }

  /// Apply skew Y transform
  static void _applySkewY(String value, FlutterWindStyle style) {
    double degrees = 0.0;
    
    if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: skew-y-[10deg]
      final inner = value.substring(1, value.length - 1).replaceAll('deg', '');
      degrees = double.tryParse(inner) ?? 0.0;
    } else {
      // Handle numeric values (assumed to be in degrees)
      degrees = double.tryParse(value) ?? 0.0;
    }
    
    // Convert degrees to radians
    final radians = degrees * (math.pi / 180.0);
    
    style.transform ??= Matrix4.identity();
    // Apply skew Y (this is a bit tricky in Matrix4)
    style.transform!.setEntry(0, 1, math.tan(radians));
  }

  /// Apply transform origin
  static void _applyOrigin(String value, FlutterWindStyle style) {
    if (originValues.containsKey(value)) {
      style.transformAlignment = originValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: origin-[10px_20px]
      final inner = value.substring(1, value.length - 1);
      final parts = inner.split('_');
      if (parts.length == 2) {
        final x = double.tryParse(parts[0].replaceAll('px', '')) ?? 0.0;
        final y = double.tryParse(parts[1].replaceAll('px', '')) ?? 0.0;
        // Convert to Alignment (values between -1 and 1)
        style.transformAlignment = Alignment(x / 50.0 - 1, y / 50.0 - 1);
      }
    }
  }
}