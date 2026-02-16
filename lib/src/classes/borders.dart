import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutterwind_core/src/classes/colors.dart';

class BordersClass {
  static const Map<String, BorderRadius> borderRadiusScale = {
    'none': BorderRadius.zero,
    'sm': BorderRadius.all(Radius.circular(2)),
    '': BorderRadius.all(Radius.circular(4)),
    'md': BorderRadius.all(Radius.circular(8)),
    'lg': BorderRadius.all(Radius.circular(10)),
    'xl': BorderRadius.all(Radius.circular(12)),
    '2xl': BorderRadius.all(Radius.circular(16)),
    '3xl': BorderRadius.all(Radius.circular(24)),
    'full': BorderRadius.all(Radius.circular(9999)),
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('rounded')) {
      String value = cls.substring('rounded'.length);
      if (value.startsWith('-')) value = value.substring(1);
      
      // Handle directional border radius
      if (value.startsWith('l-')) {
        final sizeKey = value.substring(2);
        final radius = _getRadiusValue(sizeKey);
        if (radius != null) {
          final current = style.borderRadius ?? BorderRadius.zero;
          style.borderRadius = BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            topRight: current.topRight,
            bottomRight: current.bottomRight,
          );
        }
        return;
      } else if (value.startsWith('r-')) {
        final sizeKey = value.substring(2);
        final radius = _getRadiusValue(sizeKey);
        if (radius != null) {
          final current = style.borderRadius ?? BorderRadius.zero;
          style.borderRadius = BorderRadius.only(
            topLeft: current.topLeft,
            bottomLeft: current.bottomLeft,
            topRight: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          );
        }
        return;
      } else if (value.startsWith('t-')) {
        final sizeKey = value.substring(2);
        final radius = _getRadiusValue(sizeKey);
        if (radius != null) {
          final current = style.borderRadius ?? BorderRadius.zero;
          style.borderRadius = BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: current.bottomLeft,
            bottomRight: current.bottomRight,
          );
        }
        return;
      } else if (value.startsWith('b-')) {
        final sizeKey = value.substring(2);
        final radius = _getRadiusValue(sizeKey);
        if (radius != null) {
          final current = style.borderRadius ?? BorderRadius.zero;
          style.borderRadius = BorderRadius.only(
            topLeft: current.topLeft,
            topRight: current.topRight,
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          );
        }
        return;
      }
      
      // Original all-corners logic
      if (value.startsWith('[') && value.endsWith(']')) {
        final inner = value.substring(1, value.length - 1);
        double? radius = double.tryParse(inner);
        if (radius != null) {
          style.borderRadius = BorderRadius.all(Radius.circular(radius));
        }
      } else if (value.isEmpty) {
        style.borderRadius = BorderRadius.all(Radius.circular(4));
      } else {
        if (borderRadiusScale.containsKey(value)) {
          style.borderRadius = borderRadiusScale[value];
        }
      }
    } else if (cls.startsWith('border')) {
      // Handle border width and color
      final value = cls.substring('border'.length);

      if (value.isEmpty) {
        // 'border' class -> default width 1px
        style.borderWidth = 1.0;
        return;
      }

      if (value.startsWith('-')) {
        final param = value.substring(1); // remove dash

        // Handle directional borders first (border-l-0, border-r-0, etc.)
        if (param.startsWith('l-') || param.startsWith('r-') ||
            param.startsWith('t-') || param.startsWith('b-')) {
          final direction = param[0]; // l, r, t, or b
          final widthStr = param.substring(2); // everything after 'l-'
          final width = double.tryParse(widthStr) ?? (widthStr == '0' ? 0.0 : null);
          
          if (width != null) {
            final defaultColor = style.borderColor ?? const Color(0xFFE5E7EB);
            final currentBorder = style.border;
            
            // Get current border sides or defaults
            final currentLeft = currentBorder?.left ?? BorderSide(color: defaultColor, width: style.borderWidth ?? 1.0);
            final currentRight = currentBorder?.right ?? BorderSide(color: defaultColor, width: style.borderWidth ?? 1.0);
            final currentTop = currentBorder?.top ?? BorderSide(color: defaultColor, width: style.borderWidth ?? 1.0);
            final currentBottom = currentBorder?.bottom ?? BorderSide(color: defaultColor, width: style.borderWidth ?? 1.0);
            
            switch (direction) {
              case 'l':
                style.border = Border(
                  left: width == 0.0 ? BorderSide.none : BorderSide(color: defaultColor, width: width),
                  right: currentRight,
                  top: currentTop,
                  bottom: currentBottom,
                );
                break;
              case 'r':
                style.border = Border(
                  left: currentLeft,
                  right: width == 0.0 ? BorderSide.none : BorderSide(color: defaultColor, width: width),
                  top: currentTop,
                  bottom: currentBottom,
                );
                break;
              case 't':
                style.border = Border(
                  left: currentLeft,
                  right: currentRight,
                  top: width == 0.0 ? BorderSide.none : BorderSide(color: defaultColor, width: width),
                  bottom: currentBottom,
                );
                break;
              case 'b':
                style.border = Border(
                  left: currentLeft,
                  right: currentRight,
                  top: currentTop,
                  bottom: width == 0.0 ? BorderSide.none : BorderSide(color: defaultColor, width: width),
                );
                break;
            }
          }
          return;
        }

        // Handle border width
        if (param.startsWith('[') && param.endsWith(']')) {
          // Arbitrary width or color? usually width if just number px
          // but could be color. standard tailwind logic:
          // border-[3px] is width
          // border-[#red] is color
          final inner = param.substring(1, param.length - 1);
          if (inner.startsWith('#') ||
              inner.startsWith('rgb') ||
              inner.startsWith('hsl')) {
            style.borderColor = ColorsClass.parseColor(inner);
          } else {
            style.borderWidth = double.tryParse(inner.replaceAll('px', ''));
          }
        } else {
          // Check if it's a number (width) or color
          final width = double.tryParse(param);
          if (width != null) {
            // border-2, border-4 etc
            // Tailwind default border widths are 1, 2, 4, 8 typically mapping to px directly?
            // No, border-2 is 2px. border-4 is 4px.
            style.borderWidth = width;
          } else {
            // It's likely a color like border-red-500 or border-input
            final color = ColorsClass.parseColor(param);
            if (color != null) {
              style.borderColor = color;
            }
          }
        }
      }
    } else if (cls.startsWith('ring-offset-')) {
      // Handle ring offset utilities BEFORE ring utilities
      // ring-offset-0, ring-offset-1, ring-offset-2, ring-offset-4, ring-offset-8
      // ring-offset-[3px] (arbitrary width)
      // ring-offset-<color> (e.g. ring-offset-white, ring-offset-slate-50)
      // ring-offset-<color>/<opacity> (e.g. ring-offset-white/50)
      // ring-offset-[#hex] (arbitrary color)
      final param = cls.substring('ring-offset-'.length);

      if (param.startsWith('[') && param.endsWith(']')) {
        // Arbitrary value: ring-offset-[3px] or ring-offset-[#50d71e]
        final inner = param.substring(1, param.length - 1);
        if (inner.startsWith('#') || inner.startsWith('rgb') || inner.startsWith('hsl')) {
          style.ringOffsetColor = ColorsClass.parseColor(inner);
        } else {
          style.ringOffsetWidth = double.tryParse(inner.replaceAll('px', ''));
        }
      } else if (param.contains('/')) {
        // ring-offset-<color>/<opacity>
        final parts = param.split('/');
        if (parts.length == 2) {
          final color = ColorsClass.parseColor(parts[0]);
          final opacity = int.tryParse(parts[1]);
          if (color != null && opacity != null) {
            style.ringOffsetColor = color.withOpacity(opacity / 100.0);
          }
        }
      } else {
        // Check if it's a numeric width first
        final width = double.tryParse(param);
        if (width != null) {
          // ring-offset-0, ring-offset-1, ring-offset-2, ring-offset-4, ring-offset-8
          style.ringOffsetWidth = width;
        } else {
          // It's a color token: ring-offset-white, ring-offset-slate-900, etc.
          final color = ColorsClass.parseColor(param);
          if (color != null) {
            style.ringOffsetColor = color;
          }
        }
      }
    } else if (cls.startsWith('ring')) {
      // Handle ring (focus ring) styles - creates box-shadow ring without layout impact
      final value = cls.substring('ring'.length);

      if (value.isEmpty) {
        // 'ring' class -> default ring of 3px
        style.ringWidth = 3.0;
        return;
      }

      if (value.startsWith('-')) {
        final param = value.substring(1);

        // Handle ring width: ring-0, ring-1, ring-2, ring-[3px]
        if (param == '0') {
          style.ringWidth = 0.0;
        } else if (param.startsWith('[') && param.endsWith(']')) {
          // Arbitrary ring width like ring-[3px]
          final inner = param.substring(1, param.length - 1);
          style.ringWidth = double.tryParse(inner.replaceAll('px', ''));
        } else if (param.contains('/')) {
          // Handle ring color with opacity: ring-ring/20, ring-destructive/20, etc.
          final parts = param.split('/');
          if (parts.length == 2) {
            final colorStr = parts[0];
            final opacityStr = parts[1];
            
            // Parse the color - handle token colors like 'ring', 'destructive'
            final color = ColorsClass.parseColor(colorStr);
            final opacity = int.tryParse(opacityStr);
            
            if (color != null && opacity != null) {
              // Apply opacity to color (0-100 scale to 0-1 scale)
              final opacityDouble = opacity / 100.0;
              final withOpacity = color.withOpacity(opacityDouble);
              style.ringColor = withOpacity;
            }
          }
        } else {
          // Standard ring widths: 1, 2, 4, 8 or colors
          final width = double.tryParse(param);
          if (width != null) {
            // It's a width value
            style.ringWidth = width;
          } else {
            // It's a color like ring-red-500 or ring-ring or ring-destructive
            final color = ColorsClass.parseColor(param);
            if (color != null) {
              style.ringColor = color;
            }
          }
        }
      }
    }
  }

  static double? _getRadiusValue(String sizeKey) {
    if (sizeKey == 'none') return 0.0;
    if (sizeKey == 'sm') return 2.0;
    if (sizeKey == '') return 4.0;
    if (sizeKey == 'md') return 6.0;
    if (sizeKey == 'lg') return 8.0;
    if (sizeKey == 'xl') return 12.0;
    if (sizeKey == '2xl') return 16.0;
    if (sizeKey == '3xl') return 24.0;
    if (sizeKey == 'full') return 9999.0;
    
    // Handle arbitrary values like [4px]
    if (sizeKey.startsWith('[') && sizeKey.endsWith(']')) {
      final inner = sizeKey.substring(1, sizeKey.length - 1);
      return double.tryParse(inner.replaceAll('px', ''));
    }
    
    return null;
  }
}
