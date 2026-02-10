import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';

class TypographyClass {
  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('text-')) {
      final value = cls.substring(5);
      if (value == 'center') {
        style.textAlign = TextAlign.center;
      } else if (value == 'left') {
        style.textAlign = TextAlign.left;
      } else if (value == 'right') {
        style.textAlign = TextAlign.right;
      } else if (value == 'justify') {
        style.textAlign = TextAlign.justify;
      } else {
        final semanticColor = TailwindConfig.resolveColorToken(value);
        if (semanticColor != null) {
          style.textColor = semanticColor;
          return;
        }
        double? size = _parseTextSize(value);
        if (size != null) {
          style.textSize = size;
        }
      }
    } else if (cls.startsWith('font-')) {
      final value = cls.substring(5);
      FontWeight? weight = _parseFontWeight(value);
      if (weight != null) {
        style.fontWeight = weight;
      }
    } else if (cls.startsWith('decoration-')) {
      _applyTextDecoration(cls.substring(11), style);
    } else if (cls.startsWith('uppercase') || cls.startsWith('lowercase') || 
               cls.startsWith('capitalize') || cls.startsWith('normal-case')) {
      _applyTextTransform(cls, style);
    } else if (cls.startsWith('indent-')) {
      _applyTextIndent(cls.substring(7), style);
    } else if (cls.startsWith('list-')) {
      _applyListStyle(cls.substring(5), style);
    } else if (cls.startsWith('numeric-')) {
      _applyFontVariantNumeric(cls.substring(8), style);
    }
  }

  static double? _parseTextSize(String value) {
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);
      return double.tryParse(inner);
    } else {
      return TailwindConfig.fontSize[value];
    }
  }

  static FontWeight? _parseFontWeight(String value) {
    if (TailwindConfig.fontWeight.containsKey(value)) {
      return TailwindConfig.fontWeight[value];
    }
    return null;
  }
  
  // Text decoration utilities (underline, line-through, etc.)
  static void _applyTextDecoration(String value, FlutterWindStyle style) {
    switch (value) {
      case 'underline':
        style.textDecoration = TextDecoration.underline;
        break;
      case 'overline':
        style.textDecoration = TextDecoration.overline;
        break;
      case 'line-through':
        style.textDecoration = TextDecoration.lineThrough;
        break;
      case 'none':
        style.textDecoration = TextDecoration.none;
        break;
    }
  }
  
  // Text transform utilities (uppercase, lowercase, capitalize)
  static void _applyTextTransform(String value, FlutterWindStyle style) {
    switch (value) {
      case 'uppercase':
        style.textTransform = 'uppercase';
        break;
      case 'lowercase':
        style.textTransform = 'lowercase';
        break;
      case 'capitalize':
        style.textTransform = 'capitalize';
        break;
      case 'normal-case':
        style.textTransform = 'none';
        break;
    }
  }
  
  // Text indent utilities
  static void _applyTextIndent(String value, FlutterWindStyle style) {
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);
      style.textIndent = double.tryParse(inner);
    } else {
      final spacing = TailwindConfig.spacing[value];
      if (spacing != null) {
        style.textIndent = spacing;
      }
    }
  }
  
  // List style utilities
  static void _applyListStyle(String value, FlutterWindStyle style) {
    switch (value) {
      case 'none':
        style.listStyleType = 'none';
        break;
      case 'disc':
        style.listStyleType = 'disc';
        break;
      case 'decimal':
        style.listStyleType = 'decimal';
        break;
      case 'circle':
        style.listStyleType = 'circle';
        break;
      case 'square':
        style.listStyleType = 'square';
        break;
      case 'roman':
        style.listStyleType = 'roman';
        break;
      case 'alpha':
        style.listStyleType = 'alpha';
        break;
    }
  }
  
  // Font variant numeric utilities
  static void _applyFontVariantNumeric(String value, FlutterWindStyle style) {
    switch (value) {
      case 'normal':
        style.fontVariantNumeric = null;
        break;
      case 'ordinal':
        style.fontVariantNumeric = const FontFeature.ordinalForms();
        break;
      case 'slashed-zero':
        style.fontVariantNumeric = const FontFeature.slashedZero();
        break;
      case 'lining-nums':
        style.fontVariantNumeric = const FontFeature.liningFigures();
        break;
      case 'oldstyle-nums':
        style.fontVariantNumeric = const FontFeature.oldstyleFigures();
        break;
      case 'proportional-nums':
        style.fontVariantNumeric = const FontFeature.proportionalFigures();
        break;
      case 'tabular-nums':
        style.fontVariantNumeric = const FontFeature.tabularFigures();
        break;
      case 'diagonal-fractions':
        style.fontVariantNumeric = const FontFeature.fractions();
        break;
      case 'stacked-fractions':
        style.fontVariantNumeric = const FontFeature.alternativeFractions();
        break;
    }
  }
}
