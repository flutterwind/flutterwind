import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class SizingClass {
  // A basic scale for spacing (you can adjust as needed).
  static const Map<String, double> sizingScale = {
    '0': 0.0,
    '1': 4.0,
    '2': 8.0,
    '3': 12.0,
    '4': 16.0,
    '5': 20.0,
    '6': 24.0,
    '8': 32.0,
    '10': 40.0,
    '12': 48.0,
    '16': 64.0,
    '20': 80.0,
    '24': 96.0,
    '32': 128.0,
  };

  // Container size tokens from Tailwind (in pixels).
  static const Map<String, double> containerSizes = {
    '3xs': 256.0,
    '2xs': 288.0,
    'xs': 320.0,
    'sm': 384.0,
    'md': 448.0,
    'lg': 512.0,
    'xl': 576.0,
    '2xl': 672.0,
    '3xl': 768.0,
    '4xl': 896.0,
    '5xl': 1024.0,
    '6xl': 1152.0,
    '7xl': 1280.0,
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('w-')) {
      final value = cls.substring(2);
      _applyWidth(value, style);
    } else if (cls.startsWith('h-')) {
      final value = cls.substring(2);
      _applyHeight(value, style);
    } else if (cls.startsWith('size-')) {
      final value = cls.substring(5);
      _applySize(value, style);
    } else if (cls.startsWith('overflow-')) {
      if(cls == 'overflow-scroll' || cls == 'overflow-auto' || cls == 'overflow-x-scroll' || cls == 'overflow-y-scroll') {
        style.overFlowScroll = true;
      }

      if(cls == 'overflow-x-scroll' || cls == 'overflow-x-auto') {
        style.overFlowScrollAxis = Axis.horizontal;
      }

      if(cls == 'overflow-y-scroll' || cls == 'overflow-y-auto') {
        style.overFlowScrollAxis = Axis.vertical;
      }

      if(cls == 'overflow-hidden') {
        style.overFlowHidden = true;
      }
    }
  }

  static void _applyWidth(String value, FlutterWindStyle style) {
    // Support arbitrary value: e.g., w-[250] or w-[250px]
    if (value.startsWith('[') && value.endsWith(']')) {
      // final inner = value.substring(1, value.length - 1).replaceAll('px', '');
      // double? width = double.tryParse(inner);
      // if (width != null) {
      //   style.width = width;
      // }
      final inner = value.substring(1, value.length - 1);
      if (inner.endsWith('%')) {
        final numStr = inner.replaceAll('%', '');
        double? percent = double.tryParse(numStr);
        if (percent != null) {
          final view = WidgetsBinding.instance.platformDispatcher.views.first;
          final screenWidth = view.physicalSize.width / view.devicePixelRatio;
          final screenWidthParam = screenWidth * (percent / 100);
          style.width = screenWidth * (percent / 100);
        }
      } else {
        final numStr = inner.replaceAll('px', '');
        double? width = double.tryParse(numStr);
        if (width != null) {
          style.width = width;
        }
      }
    }
    // Support fractional values: e.g., w-1/2
    else if (value.contains('/')) {
      final parts = value.split('/');
      if (parts.length == 2) {
        double? numerator = double.tryParse(parts[0]);
        double? denominator = double.tryParse(parts[1]);
        if (numerator != null && denominator != null && denominator != 0) {
          style.widthFactor = numerator / denominator;
        }
      }
    }
    // Keywords
    else if (value == 'full') {
      style.widthFactor = 1.0;
    } else if (value == 'screen') {
      // For screen, you might treat it as full width.
      style.widthFactor = 1.0;
    }
    // Look up in sizing scale
    else if (sizingScale.containsKey(value)) {
      style.width = sizingScale[value];
    }
    // Look up in container sizes
    else if (containerSizes.containsKey(value)) {
      style.width = containerSizes[value];
    } else if (value == 'auto') {
      // Set width to null to allow the widget to size itself based on content
      // This mimics Tailwind CSS's w-auto behavior
      style.width = null;
      style.widthFactor = null;
    }
  }

  static void _applyHeight(String value, FlutterWindStyle style) {
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1).replaceAll('px', '');
      double? height = double.tryParse(inner);
      if (height != null) {
        style.height = height;
      }
    } else if (value.contains('/')) {
      // Fractional height
      final parts = value.split('/');
      if (parts.length == 2) {
        double? numerator = double.tryParse(parts[0]);
        double? denominator = double.tryParse(parts[1]);
        if (numerator != null && denominator != null && denominator != 0) {
          style.heightFactor = numerator / denominator;
        }
      }
    } else if (value == 'full') {
      style.heightFactor = 1.0;
    } else if (value == 'screen') {
      style.heightFactor = 1.0;
    } else if (sizingScale.containsKey(value)) {
      style.height = sizingScale[value];
    } else if (containerSizes.containsKey(value)) {
      style.height = containerSizes[value];
    } else if (value == 'auto') {
      // Set height to null to allow the widget to size itself based on content
      // This mimics Tailwind CSS's h-auto behavior
      style.height = null;
      style.heightFactor = null;
    }
  }

  static void _applySize(String value, FlutterWindStyle style) {
    // Apply for both width and height.
    _applyWidth(value, style);
    _applyHeight(value, style);
  }
}
