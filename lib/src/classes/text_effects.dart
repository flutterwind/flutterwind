import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

enum TextSelectionBehavior { none, text, all }

class TextEffects {
  // Text shadow presets
  static final Map<String, List<Shadow>> textShadowValues = {
    'text-shadow-sm': [
      Shadow(
        color: Colors.black.withOpacity(0.1),
        offset: const Offset(0, 1),
        blurRadius: 2,
      )
    ],
    'text-shadow-md': [
      Shadow(
        color: Colors.black.withOpacity(0.15),
        offset: const Offset(0, 2),
        blurRadius: 4,
      )
    ],
    'text-shadow-lg': [
      Shadow(
        color: Colors.black.withOpacity(0.2),
        offset: const Offset(0, 4),
        blurRadius: 6,
      )
    ],
    'text-shadow-xl': [
      Shadow(
        color: Colors.black.withOpacity(0.25),
        offset: const Offset(0, 6),
        blurRadius: 8,
      )
    ],
    'text-shadow-2xl': [
      Shadow(
        color: Colors.black.withOpacity(0.3),
        offset: const Offset(0, 8),
        blurRadius: 12,
      )
    ],
    'text-shadow-none': [],
  };

  // Letter spacing presets
  static const Map<String, double> letterSpacingValues = {
    'tracking-tighter': -0.05,
    'tracking-tight': -0.025,
    'tracking-normal': 0,
    'tracking-wide': 0.025,
    'tracking-wider': 0.05,
    'tracking-widest': 0.1,
  };

  // Word spacing presets
  static const Map<String, double> wordSpacingValues = {
    'word-spacing-tighter': -0.05,
    'word-spacing-tight': -0.025,
    'word-spacing-normal': 0,
    'word-spacing-wide': 0.025,
    'word-spacing-wider': 0.05,
    'word-spacing-widest': 0.1,
  };

  // Line height presets
  static const Map<String, double> lineHeightValues = {
    'leading-none': 1.0,
    'leading-tight': 1.25,
    'leading-snug': 1.375,
    'leading-normal': 1.5,
    'leading-relaxed': 1.625,
    'leading-loose': 2.0,
  };

  // Text overflow presets
  static const Map<String, TextOverflow> textOverflowValues = {
    'truncate': TextOverflow.ellipsis,
    'text-ellipsis': TextOverflow.ellipsis,
    'text-clip': TextOverflow.clip,
    'text-visible': TextOverflow.visible,
  };

  // Text wrapping presets
  static const Map<String, bool> textWrapValues = {
    'text-wrap': true,
    'whitespace-normal': true,
    'whitespace-nowrap': false,
    'whitespace-pre': false,
    'whitespace-pre-line': true,
    'whitespace-pre-wrap': true,
  };

  // Text selection presets
  static final Map<String, TextSelectionBehavior> textSelectionValues = {
    'select-none': TextSelectionBehavior.none,
    'select-text': TextSelectionBehavior.text,
    'select-all': TextSelectionBehavior.all,
  };

  // Text scaling presets
  static const Map<String, double> textScaleValues = {
    'scale-50': 0.5,
    'scale-75': 0.75,
    'scale-90': 0.9,
    'scale-95': 0.95,
    'scale-100': 1.0,
    'scale-105': 1.05,
    'scale-110': 1.1,
    'scale-125': 1.25,
    'scale-150': 1.5,
  };

  // Text direction presets
  static const Map<String, TextDirection> textDirectionValues = {
    'rtl': TextDirection.rtl,
    'ltr': TextDirection.ltr,
  };

  // Text alignment presets
  static const Map<String, TextAlign> textAlignValues = {
    'text-left': TextAlign.left,
    'text-center': TextAlign.center,
    'text-right': TextAlign.right,
    'text-justify': TextAlign.justify,
    'text-start': TextAlign.start,
    'text-end': TextAlign.end,
  };

  // Text decoration presets
  static const Map<String, TextDecoration> textDecorationValues = {
    'underline': TextDecoration.underline,
    'line-through': TextDecoration.lineThrough,
    'overline': TextDecoration.overline,
    'no-underline': TextDecoration.none,
  };

  // Text transform presets
  static const Map<String, String> textTransformValues = {
    'uppercase': 'uppercase',
    'lowercase': 'lowercase',
    'capitalize': 'capitalize',
    'normal-case': 'none',
  };

  // Font variant presets
  static const Map<String, FontFeature> fontVariantValues = {
    'small-caps': FontFeature.enable('smcp'),
    'oldstyle-nums': FontFeature.enable('onum'),
    'lining-nums': FontFeature.enable('lnum'),
    'tabular-nums': FontFeature.enable('tnum'),
    'proportional-nums': FontFeature.enable('pnum'),
    'slashed-zero': FontFeature.enable('zero'),
    'ordinal': FontFeature.enable('ordn'),
    'fractions': FontFeature.enable('frac'),
    'discretionary-ligatures': FontFeature.enable('dlig'),
    'historical-ligatures': FontFeature.enable('hlig'),
    'contextual': FontFeature.enable('calt'),
  };

  static void apply(String cls, FlutterWindStyle style) {
    // Handle text shadow
    if (cls.startsWith('text-shadow-')) {
      _applyTextShadow(cls, style);
    }
    // Handle letter spacing
    else if (cls.startsWith('tracking-')) {
      _applyLetterSpacing(cls, style);
    }
    // Handle word spacing
    else if (cls.startsWith('word-spacing-')) {
      _applyWordSpacing(cls, style);
    }
    // Handle line height
    else if (cls.startsWith('leading-')) {
      _applyLineHeight(cls, style);
    }
    // Handle text overflow
    else if (cls == 'truncate' ||
        cls == 'text-ellipsis' ||
        cls == 'text-clip' ||
        cls == 'text-visible') {
      _applyTextOverflow(cls, style);
    }
    // Handle text wrapping
    else if (cls == 'text-wrap' || cls.startsWith('whitespace-')) {
      _applyTextWrap(cls, style);
    }
    // Handle text selection
    else if (cls.startsWith('select-')) {
      _applyTextSelection(cls, style);
    }
    // Handle text scaling
    else if (cls.startsWith('scale-')) {
      _applyTextScale(cls, style);
    }
    // Handle text direction
    else if (cls == 'rtl' || cls == 'ltr') {
      _applyTextDirection(cls, style);
    }
    // Handle text alignment
    else if (cls.startsWith('text-') && textAlignValues.containsKey(cls)) {
      _applyTextAlignment(cls, style);
    }
    // Handle text decoration
    else if (textDecorationValues.containsKey(cls)) {
      _applyTextDecoration(cls, style);
    }
    // Handle text transform
    else if (textTransformValues.containsKey(cls)) {
      _applyTextTransform(cls, style);
    }
    // Handle font variant
    else if (fontVariantValues.containsKey(cls)) {
      _applyFontVariant(cls, style);
    }
  }

  static void _applyTextShadow(String cls, FlutterWindStyle style) {
    if (textShadowValues.containsKey(cls)) {
      style.textShadows = textShadowValues[cls];
    }
  }

  static void _applyLetterSpacing(String cls, FlutterWindStyle style) {
    if (letterSpacingValues.containsKey(cls)) {
      style.letterSpacing = letterSpacingValues[cls];
    } else if (cls.startsWith('tracking-[') && cls.endsWith(']')) {
      // Handle arbitrary values: tracking-[0.1]
      final inner = cls.substring(9, cls.length - 1);
      final spacing = double.tryParse(inner);
      if (spacing != null) {
        style.letterSpacing = spacing;
      }
    }
  }

  static void _applyWordSpacing(String cls, FlutterWindStyle style) {
    if (wordSpacingValues.containsKey(cls)) {
      style.wordSpacing = wordSpacingValues[cls];
    } else if (cls.startsWith('word-spacing-[') && cls.endsWith(']')) {
      // Handle arbitrary values: word-spacing-[0.1]
      final inner = cls.substring(13, cls.length - 1);
      final spacing = double.tryParse(inner);
      if (spacing != null) {
        style.wordSpacing = spacing;
      }
    }
  }

  static void _applyLineHeight(String cls, FlutterWindStyle style) {
    if (lineHeightValues.containsKey(cls)) {
      style.lineHeight = lineHeightValues[cls];
    } else if (cls.startsWith('leading-[') && cls.endsWith(']')) {
      // Handle arbitrary values: leading-[1.5]
      final inner = cls.substring(8, cls.length - 1);
      final height = double.tryParse(inner);
      if (height != null) {
        style.lineHeight = height;
      }
    }
  }

  static void _applyTextOverflow(String cls, FlutterWindStyle style) {
    if (textOverflowValues.containsKey(cls)) {
      style.textOverflow = textOverflowValues[cls];
      if (style.textOverflow == TextOverflow.ellipsis) {
        style.textWrap = false;
      }
    }
  }

  static void _applyTextWrap(String cls, FlutterWindStyle style) {
    if (textWrapValues.containsKey(cls)) {
      style.textWrap = textWrapValues[cls];
    }
  }

  static void _applyTextSelection(String cls, FlutterWindStyle style) {
    if (textSelectionValues.containsKey(cls)) {
      style.textSelection = textSelectionValues[cls];
    }
  }

  static void _applyTextScale(String cls, FlutterWindStyle style) {
    if (textScaleValues.containsKey(cls)) {
      style.textScale = textScaleValues[cls];
    } else if (cls.startsWith('scale-[') && cls.endsWith(']')) {
      // Handle arbitrary values: scale-[1.2]
      final inner = cls.substring(7, cls.length - 1);
      final scale = double.tryParse(inner);
      if (scale != null) {
        style.textScale = scale;
      }
    }
  }

  static void _applyTextDirection(String cls, FlutterWindStyle style) {
    if (textDirectionValues.containsKey(cls)) {
      style.textDirection = textDirectionValues[cls];
    }
  }

  static void _applyTextAlignment(String cls, FlutterWindStyle style) {
    if (textAlignValues.containsKey(cls)) {
      style.textAlign = textAlignValues[cls];
    }
  }

  static void _applyTextDecoration(String cls, FlutterWindStyle style) {
    if (textDecorationValues.containsKey(cls)) {
      style.textDecoration = textDecorationValues[cls];
    }
  }

  static void _applyTextTransform(String cls, FlutterWindStyle style) {
    if (textTransformValues.containsKey(cls)) {
      style.textTransform = textTransformValues[cls];
    }
  }

  static void _applyFontVariant(String cls, FlutterWindStyle style) {
    if (fontVariantValues.containsKey(cls)) {
      style.fontVariantNumeric = fontVariantValues[cls];
    }
  }
}
