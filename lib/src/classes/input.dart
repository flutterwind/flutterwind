import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutterwind_core/src/classes/colors.dart';
import 'package:flutterwind_core/src/classes/sizing.dart';
import 'package:flutterwind_core/src/classes/typography.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';

class InputClass {
  static void apply(String className, FlutterWindStyle style) {
    // Aliases used in docs/examples for border styles
    if (className == 'input-none') {
      _applyBorderStyle('none', style);
      return;
    }
    if (className == 'input-outline') {
      _applyBorderStyle('outline', style);
      return;
    }
    if (className == 'input-underline') {
      _applyBorderStyle('underline', style);
      return;
    }

    // Background colors
    if (className.startsWith('bg-')) {
      ColorsClass.apply(className, style);
    }
    // Ring style (typically used with focus/input-focus variants)
    else if (className.startsWith('ring-')) {
      final color = className.substring(5);
      final ringColor = _parseColor(color);
      if (ringColor != null) {
        style.inputFocusColor = ringColor;
        style.inputFocusWidth = 2.0;
      }
    }
    // Border styles
    else if (className.startsWith('border-')) {
      _applyBorderStyle(className.substring(7), style);
    }
    // Border radius
    else if (className.startsWith('rounded-')) {
      _applyBorderRadius(className.substring(8), style);
    }
    // Border width
    else if (className.startsWith('border-w-')) {
      _applyBorderWidth(className.substring(9), style);
    }
    // Text colors
    else if (className.startsWith('text-')) {
      ColorsClass.apply(className, style);
    }
    // Input states
    else if (className.startsWith('focus:')) {
      _applyFocusStyle(className.substring(6), style);
    } else if (className.startsWith('hover:')) {
      _applyHoverStyle(className.substring(6), style);
    } else if (className.startsWith('dark:')) {
      _applyDarkModeStyle(className.substring(5), style);
    }
    // Input sizes
    else if (className.startsWith('input-')) {
      _applySizeStyle(className.substring(6), style);
    }
    // Custom padding
    else if (className.startsWith('p-')) {
      SizingClass.apply(className, style);
    }
    // Custom font size
    else if (className.startsWith('text-')) {
      TypographyClass.apply(className, style);
    }
  }

  static void _applyBorderStyle(
      String style, FlutterWindStyle flutterWindStyle) {
    switch (style) {
      case 'none':
        flutterWindStyle.inputBorder = InputBorder.none;
        break;
      case 'outline':
        flutterWindStyle.inputBorder = const OutlineInputBorder();
        break;
      case 'underline':
        flutterWindStyle.inputBorder = const UnderlineInputBorder();
        break;
      case 'rounded':
        flutterWindStyle.inputBorder = OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius:
              BorderRadius.circular(TailwindConfig.borderRadius['md'] ?? 4.0),
        );
        break;
      default:
        // Handle border colors using ColorsClass
        final color = _parseColor(style);
        if (color != null) {
          final currentBorder =
              flutterWindStyle.inputBorder ?? const OutlineInputBorder();
          if (currentBorder is OutlineInputBorder) {
            flutterWindStyle.inputBorder = currentBorder.copyWith(
              borderSide: BorderSide(color: color),
            );
          }
        }
    }
  }

  static void _applyBorderRadius(String radius, FlutterWindStyle style) {
    final value = TailwindConfig.borderRadius[radius];
    if (value != null) {
      final currentBorder = style.inputBorder ?? const OutlineInputBorder();
      if (currentBorder is OutlineInputBorder) {
        style.inputBorder = currentBorder.copyWith(
          borderRadius: BorderRadius.circular(value),
        );
      }
    }
  }

  static void _applyBorderWidth(String width, FlutterWindStyle style) {
    final value = TailwindConfig.borderWidth[width];
    if (value != null) {
      final currentBorder = style.inputBorder ?? const OutlineInputBorder();
      if (currentBorder is OutlineInputBorder) {
        style.inputBorder = currentBorder.copyWith(
          borderSide: BorderSide(width: value),
        );
      }
    }
  }

  static void _applyFocusStyle(
      String style, FlutterWindStyle flutterWindStyle) {
    if (style.startsWith('ring-')) {
      final color = style.substring(5);
      final ringColor = _parseColor(color);
      if (ringColor != null) {
        flutterWindStyle.inputFocusColor = ringColor;
        flutterWindStyle.inputFocusWidth = 2.0;
      }
    } else if (style.startsWith('border-')) {
      final color = style.substring(7);
      final borderColor = _parseColor(color);
      if (borderColor != null) {
        flutterWindStyle.inputFocusBorderColor = borderColor;
      }
    }
  }

  static void _applyHoverStyle(
      String style, FlutterWindStyle flutterWindStyle) {
    if (style.startsWith('bg-')) {
      final color = style.substring(3);
      final bgColor = _parseColor(color);
      if (bgColor != null) {
        flutterWindStyle.inputHoverBackgroundColor = bgColor;
      }
    }
  }

  static void _applyDarkModeStyle(
      String style, FlutterWindStyle flutterWindStyle) {
    if (style.startsWith('bg-')) {
      final color = style.substring(3);
      final bgColor = _parseColor(color);
      if (bgColor != null) {
        flutterWindStyle.inputHoverBackgroundColor = bgColor;
      }
    } else if (style.startsWith('border-')) {
      final color = style.substring(7);
      final borderColor = _parseColor(color);
      if (borderColor != null) {
        flutterWindStyle.inputHoverBorderColor = borderColor;
      }
    } else if (style.startsWith('text-')) {
      final color = style.substring(5);
      final textColor = _parseColor(color);
      if (textColor != null) {
        flutterWindStyle.textColor = textColor;
      }
    } else if (style.startsWith('focus:ring-')) {
      final color = style.substring(11);
      final ringColor = _parseColor(color);
      if (ringColor != null) {
        flutterWindStyle.inputFocusColor = ringColor;
        flutterWindStyle.inputFocusWidth = 2.0;
      }
    }
  }

  static void _applySizeStyle(String size, FlutterWindStyle style) {
    switch (size) {
      case 'xs':
        style.inputPadding = EdgeInsets.symmetric(
          horizontal: TailwindConfig.spacing['2'] ?? 8.0,
          vertical: TailwindConfig.spacing['1'] ?? 4.0,
        );
        style.inputFontSize = TailwindConfig.fontSize['xs'] ?? 12.0;
        break;
      case 'sm':
        style.inputPadding = EdgeInsets.symmetric(
          horizontal: TailwindConfig.spacing['3'] ?? 12.0,
          vertical: TailwindConfig.spacing['1.5'] ?? 6.0,
        );
        style.inputFontSize = TailwindConfig.fontSize['sm'] ?? 14.0;
        break;
      case 'md':
        style.inputPadding = EdgeInsets.symmetric(
          horizontal: TailwindConfig.spacing['4'] ?? 16.0,
          vertical: TailwindConfig.spacing['2'] ?? 8.0,
        );
        style.inputFontSize = TailwindConfig.fontSize['base'] ?? 16.0;
        break;
      case 'lg':
        style.inputPadding = EdgeInsets.symmetric(
          horizontal: TailwindConfig.spacing['5'] ?? 20.0,
          vertical: TailwindConfig.spacing['2.5'] ?? 10.0,
        );
        style.inputFontSize = TailwindConfig.fontSize['lg'] ?? 18.0;
        break;
      case 'xl':
        style.inputPadding = EdgeInsets.symmetric(
          horizontal: TailwindConfig.spacing['6'] ?? 24.0,
          vertical: TailwindConfig.spacing['3'] ?? 12.0,
        );
        style.inputFontSize = TailwindConfig.fontSize['xl'] ?? 20.0;
        break;
    }
  }

  static Color? _parseColor(String value) {
    // Try to parse as a Tailwind color
    final color = ColorsClass.baseColors[value];
    if (color != null) return color;

    // Try to parse as a Tailwind color with shade
    final parts = value.split('-');
    if (parts.length == 2) {
      final baseColor = ColorsClass.baseColors[parts[0]];
      final shade = int.tryParse(parts[1]);
      if (baseColor != null && shade != null) {
        return _getShadeColor(baseColor, shade);
      }
    }

    return null;
  }

  static Color _getShadeColor(Color baseColor, int shade) {
    // Convert base color to HSL
    final hsl = HSLColor.fromColor(baseColor);

    // Adjust lightness based on shade
    double lightness;
    switch (shade) {
      case 50:
        lightness = 0.95;
        break;
      case 100:
        lightness = 0.9;
        break;
      case 200:
        lightness = 0.8;
        break;
      case 300:
        lightness = 0.7;
        break;
      case 400:
        lightness = 0.6;
        break;
      case 500:
        lightness = 0.5;
        break;
      case 600:
        lightness = 0.4;
        break;
      case 700:
        lightness = 0.3;
        break;
      case 800:
        lightness = 0.2;
        break;
      case 900:
        lightness = 0.1;
        break;
      default:
        lightness = 0.5;
    }

    return hsl.withLightness(lightness).toColor();
  }
}
