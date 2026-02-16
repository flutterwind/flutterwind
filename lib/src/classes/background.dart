import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class BackgroundClass {
  static const Map<String, BoxFit> backgroundSizeValues = {
    'auto': BoxFit.none,
    'cover': BoxFit.cover,
    'contain': BoxFit.contain,
    'fill': BoxFit.fill,
  };

  static const Map<String, Alignment> backgroundPositionValues = {
    'center': Alignment.center,
    'top': Alignment.topCenter,
    'bottom': Alignment.bottomCenter,
    'left': Alignment.centerLeft,
    'right': Alignment.centerRight,
    'top-left': Alignment.topLeft,
    'top-right': Alignment.topRight,
    'bottom-left': Alignment.bottomLeft,
    'bottom-right': Alignment.bottomRight,
  };

  static const Map<String, BlendMode> blendModeValues = {
    'normal': BlendMode.srcOver,
    'multiply': BlendMode.multiply,
    'screen': BlendMode.screen,
    'overlay': BlendMode.overlay,
    'darken': BlendMode.darken,
    'lighten': BlendMode.lighten,
    'color-dodge': BlendMode.colorDodge,
    'color-burn': BlendMode.colorBurn,
    'hard-light': BlendMode.hardLight,
    'soft-light': BlendMode.softLight,
    'difference': BlendMode.difference,
    'exclusion': BlendMode.exclusion,
    'hue': BlendMode.hue,
    'saturation': BlendMode.saturation,
    'color': BlendMode.color,
    'luminosity': BlendMode.luminosity,
  };

  static const Map<String, ImageRepeat> backgroundRepeatValues = {
    'repeat': ImageRepeat.repeat,
    'no-repeat': ImageRepeat.noRepeat,
    'repeat-x': ImageRepeat.repeatX,
    'repeat-y': ImageRepeat.repeatY,
    'repeat-round': ImageRepeat.repeat,
    'repeat-space': ImageRepeat.repeat,
  };

  static const Map<String, BoxShape> backgroundClipValues = {
    'border': BoxShape.rectangle,
    'padding': BoxShape.rectangle,
    'content': BoxShape.rectangle,
    'text': BoxShape.rectangle,
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls == 'shader-gradient') {
      style.gradient = const LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      return;
    }

    if (cls.startsWith('blend-')) {
      _applyBlendMode(cls.substring('blend-'.length), style);
      return;
    }

    if (cls.startsWith('bg-')) {
      final value = cls.substring(3);
      if (value.startsWith('size-')) {
        _applyBackgroundSize(value.substring(5), style);
      } else if (value.startsWith('position-')) {
        _applyBackgroundPosition(value.substring(9), style);
      } else if (value.startsWith('blend-')) {
        _applyBlendMode(value.substring(6), style);
      } else if (value.startsWith('repeat-')) {
        _applyBackgroundRepeat(value.substring(7), style);
      } else if (value == 'fixed' || value == 'local' || value == 'scroll') {
        style.backgroundAttachment = value;
      } else if (value.startsWith('origin-')) {
        _applyBackgroundOrigin(value.substring(7), style);
      } else if (value.startsWith('clip-')) {
        _applyBackgroundClip(value.substring(5), style);
      } else if (value.startsWith('opacity-')) {
        _applyBackgroundOpacity(value.substring(8), style);
      } else if (value == 'transparent') {
        // Explicitly handle transparent background
        style.backgroundColor = Colors.transparent;
      } else {
        final semanticColor = TailwindConfig.resolveColorToken(value);
        if (semanticColor != null) {
          style.backgroundColor = semanticColor;
        }
      }
    }
  }

  static void _applyBackgroundSize(String value, FlutterWindStyle style) {
    if (backgroundSizeValues.containsKey(value)) {
      style.backgroundFit = backgroundSizeValues[value];
    }
  }

  static void _applyBackgroundPosition(String value, FlutterWindStyle style) {
    if (backgroundPositionValues.containsKey(value)) {
      style.backgroundAlignment = backgroundPositionValues[value];
    }
  }

  static void _applyBlendMode(String value, FlutterWindStyle style) {
    if (blendModeValues.containsKey(value)) {
      style.backgroundBlendMode = blendModeValues[value];
    }
  }

  static void _applyBackgroundRepeat(String value, FlutterWindStyle style) {
    if (backgroundRepeatValues.containsKey(value)) {
      style.backgroundRepeat = backgroundRepeatValues[value];
    }
  }

  static void _applyBackgroundOrigin(String value, FlutterWindStyle style) {
    if (backgroundPositionValues.containsKey(value)) {
      style.backgroundOrigin = value;
    }
  }

  static void _applyBackgroundClip(String value, FlutterWindStyle style) {
    if (backgroundClipValues.containsKey(value)) {
      style.backgroundClip = backgroundClipValues[value];
    }
  }

  static void _applyBackgroundOpacity(String value, FlutterWindStyle style) {
    final opacity = double.tryParse(value);
    if (opacity != null && opacity >= 0 && opacity <= 100) {
      style.backgroundOpacity = opacity / 100;
    }
  }
}
