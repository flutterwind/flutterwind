import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

/// FilterEffects class implements Tailwind CSS filter and effects functionality
/// including blur, brightness/contrast, drop shadow, and backdrop filters.
class FilterEffects {
  // Blur filter values (in pixels)
  static const Map<String, double> blurValues = {
    'none': 0.0,
    'sm': 4.0,
    'md': 8.0,
    'lg': 12.0,
    'xl': 16.0,
    '2xl': 24.0,
    '3xl': 32.0,
  };

  // Brightness filter values (as multipliers)
  static const Map<String, double> brightnessValues = {
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

  // Contrast filter values (as multipliers)
  static const Map<String, double> contrastValues = {
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

  // Drop shadow presets
  static const Map<String, BoxShadow> dropShadowValues = {
    'sm': BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
    'md': BoxShadow(
      color: Color(0x26000000),
      blurRadius: 6.0,
      offset: Offset(0, 3),
    ),
    'lg': BoxShadow(
      color: Color(0x33000000),
      blurRadius: 10.0,
      offset: Offset(0, 8),
    ),
    'xl': BoxShadow(
      color: Color(0x3D000000),
      blurRadius: 15.0,
      offset: Offset(0, 10),
    ),
    '2xl': BoxShadow(
      color: Color(0x40000000),
      blurRadius: 25.0,
      offset: Offset(0, 15),
    ),
  };

  /// Apply filter classes to the FlutterWindStyle
  static void apply(String cls, FlutterWindStyle style) {
    // Blur filters
    if (cls.startsWith('blur-')) {
      final value = cls.substring(5);
      _applyBlur(value, style);
    }
    // Backdrop blur filters
    else if (cls.startsWith('backdrop-blur-')) {
      final value = cls.substring(14);
      _applyBackdropBlur(value, style);
    }
    // Brightness filters
    else if (cls.startsWith('brightness-')) {
      final value = cls.substring(11);
      _applyBrightness(value, style);
    }
    // Contrast filters
    else if (cls.startsWith('contrast-')) {
      final value = cls.substring(9);
      _applyContrast(value, style);
    }
    // Drop shadow
    else if (cls.startsWith('drop-shadow-')) {
      final value = cls.substring(12);
      _applyDropShadow(value, style);
    }
    // Backdrop filter (general)
    else if (cls == 'backdrop-filter') {
      style.useBackdropFilter = true;
    }
  }

  /// Apply blur filter
  static void _applyBlur(String value, FlutterWindStyle style) {
    double blurAmount = 0.0;
    
    if (blurValues.containsKey(value)) {
      blurAmount = blurValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: blur-[10px]
      final inner = value.substring(1, value.length - 1).replaceAll('px', '');
      blurAmount = double.tryParse(inner) ?? 0.0;
    }
    
    if (blurAmount > 0) {
      style.imageFilter = ImageFilter.blur(
        sigmaX: blurAmount,
        sigmaY: blurAmount,
      );
    }
  }

  /// Apply backdrop blur filter
  static void _applyBackdropBlur(String value, FlutterWindStyle style) {
    double blurAmount = 0.0;
    
    if (blurValues.containsKey(value)) {
      blurAmount = blurValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: backdrop-blur-[10px]
      final inner = value.substring(1, value.length - 1).replaceAll('px', '');
      blurAmount = double.tryParse(inner) ?? 0.0;
    }
    
    if (blurAmount > 0) {
      style.backdropFilter = ImageFilter.blur(
        sigmaX: blurAmount,
        sigmaY: blurAmount,
      );
      style.useBackdropFilter = true;
    }
  }

  /// Apply brightness filter
  static void _applyBrightness(String value, FlutterWindStyle style) {
    double brightnessValue = 1.0; // Default is 100%
    
    if (brightnessValues.containsKey(value)) {
      brightnessValue = brightnessValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: brightness-[125]
      final inner = value.substring(1, value.length - 1);
      final parsed = double.tryParse(inner);
      if (parsed != null) {
        brightnessValue = parsed / 100; // Convert percentage to multiplier
      }
    }
    
    style.colorFilter = ColorFilter.matrix([
      brightnessValue, 0, 0, 0, 0,
      0, brightnessValue, 0, 0, 0,
      0, 0, brightnessValue, 0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  /// Apply contrast filter
  static void _applyContrast(String value, FlutterWindStyle style) {
    double contrastValue = 1.0; // Default is 100%
    
    if (contrastValues.containsKey(value)) {
      contrastValue = contrastValues[value]!;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: contrast-[125]
      final inner = value.substring(1, value.length - 1);
      final parsed = double.tryParse(inner);
      if (parsed != null) {
        contrastValue = parsed / 100; // Convert percentage to multiplier
      }
    }
    
    // Apply contrast matrix
    final double intercept = 0.5 * (1 - contrastValue);
    style.colorFilter = ColorFilter.matrix([
      contrastValue, 0, 0, 0, intercept * 255,
      0, contrastValue, 0, 0, intercept * 255,
      0, 0, contrastValue, 0, intercept * 255,
      0, 0, 0, 1, 0,
    ]);
  }

  /// Apply drop shadow
  static void _applyDropShadow(String value, FlutterWindStyle style) {
    if (dropShadowValues.containsKey(value)) {
      final shadow = dropShadowValues[value]!;
      style.dropShadow = shadow;
    } else if (value.startsWith('[') && value.endsWith(']')) {
      // Handle arbitrary values: drop-shadow-[0_4px_6px_rgba(0,0,0,0.1)]
      // This is complex to parse, so we'll use a simplified approach for custom shadows
      final inner = value.substring(1, value.length - 1);
      final parts = inner.split('_');
      
      if (parts.length >= 3) {
        try {
          final offsetX = double.tryParse(parts[0]) ?? 0.0;
          final offsetY = double.tryParse(parts[1].replaceAll('px', '')) ?? 4.0;
          final blurRadius = double.tryParse(parts[2].replaceAll('px', '')) ?? 6.0;
          
          // Default color with 10% opacity if not specified
          Color shadowColor = const Color(0x1A000000);
          
          // Try to parse color if provided
          if (parts.length > 3 && parts[3].startsWith('rgba')) {
            // Very simplified rgba parsing
            shadowColor = const Color(0x1A000000);
          }
          
          style.dropShadow = BoxShadow(
            color: shadowColor,
            offset: Offset(offsetX, offsetY),
            blurRadius: blurRadius,
          );
        } catch (e) {
          // Fallback to medium shadow on parsing error
          style.dropShadow = dropShadowValues['md'];
        }
      }
    }
  }
}