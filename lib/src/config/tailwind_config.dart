import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/config/sizing.dart';
import 'package:flutterwind_core/src/utils/logger.dart';
import 'colors.dart';
import 'text.dart';
import 'spacing.dart';

class TailwindConfig {
  // Container configuration
  static bool containerCenter = true;
  static double containerPadding = 32.0; // 2rem = 32px
  static Map<String, double> containerScreens = {};

  // Existing configurations
  static Map<String, double> screens = defaultBreakpoints;
  static Map<String, Map<int, Color>> colors = defaultTailwindColors;
  static Map<String, double> spacing = defaultSpacingScale;
  static Map<String, List<String>> fontFamily = {};
  static Map<String, double> fontSize = defaultFontSize;
  static Map<String, FontWeight> fontWeight = defaultFontWeight;
  static Map<String, double> borderRadius = {};
  static Map<String, double> borderWidth = {
    '0': 0.0,
    '1': 1.0,
    '2': 2.0,
    '4': 4.0,
    '8': 8.0,
  };
  static Map<String, List<BoxShadow>> boxShadow = {};
  static Map<String, double> blur = {};
  static Map<String, double> brightness = {};
  static Map<String, double> contrast = {};
  static Map<String, BoxShadow> dropShadow = {};
  static Map<String, Color> semanticColors = {
    'surface': Colors.white,
    'surface-foreground': Colors.black,
    'muted': Color(0xFFF3F4F6),
    'muted-foreground': Color(0xFF6B7280),
    'primary': Color(0xFF3B82F6),
    'primary-foreground': Colors.white,
    'danger': Color(0xFFEF4444),
    'danger-foreground': Colors.white,
  };
  static Map<String, Color> semanticColorsLight = {};
  static Map<String, Color> semanticColorsDark = {};

  // Additional theme configurations
  static Map<String, double> lineHeight = {
    'none': 1.0,
    'tight': 1.25,
    'snug': 1.375,
    'normal': 1.5,
    'relaxed': 1.625,
    'loose': 2.0,
  };

  static Map<String, double> letterSpacing = {
    'tighter': -0.05,
    'tight': -0.025,
    'normal': 0.0,
    'wide': 0.025,
    'wider': 0.05,
    'widest': 0.1,
  };

  static Map<String, double> opacity = {
    '0': 0.0,
    '5': 0.05,
    '10': 0.1,
    '20': 0.2,
    '25': 0.25,
    '30': 0.3,
    '40': 0.4,
    '50': 0.5,
    '60': 0.6,
    '70': 0.7,
    '75': 0.75,
    '80': 0.8,
    '90': 0.9,
    '95': 0.95,
    '100': 1.0,
  };

  static Map<String, int> zIndex = {
    '0': 0,
    '10': 10,
    '20': 20,
    '30': 30,
    '40': 40,
    '50': 50,
    'auto': -1,
  };

  static Map<String, List<String>> transitionProperty = {
    'none': ['none'],
    'all': ['all'],
    'DEFAULT': [
      'color',
      'background-color',
      'border-color',
      'text-decoration-color',
      'fill',
      'stroke',
      'opacity',
      'box-shadow',
      'transform',
      'filter',
      'backdrop-filter'
    ],
    'colors': [
      'color',
      'background-color',
      'border-color',
      'text-decoration-color',
      'fill',
      'stroke'
    ],
    'opacity': ['opacity'],
    'shadow': ['box-shadow'],
    'transform': ['transform'],
  };

  static Map<String, Duration> transitionDuration = {
    '75': const Duration(milliseconds: 75),
    '100': const Duration(milliseconds: 100),
    '150': const Duration(milliseconds: 150),
    '200': const Duration(milliseconds: 200),
    '300': const Duration(milliseconds: 300),
    '500': const Duration(milliseconds: 500),
    '700': const Duration(milliseconds: 700),
    '1000': const Duration(milliseconds: 1000),
  };

  static Map<String, Curve> transitionTimingFunction = {
    'linear': Curves.linear,
    'in': Curves.easeIn,
    'out': Curves.easeOut,
    'in-out': Curves.easeInOut,
  };

  static void updateFromYaml(dynamic yamlMap) {
    if (yamlMap == null) return;

    // Handle theme configuration
    if (yamlMap['theme'] != null) {
      final theme = yamlMap['theme'];

      // Parse container configuration
      if (theme['container'] != null) {
        final container = theme['container'];
        containerCenter = container['center'] ?? true;
        if (container['padding'] != null) {
          final padding = container['padding'].toString();
          containerPadding =
              double.tryParse(padding.replaceAll('rem', '')) ?? 2.0 * 16;
        }
        if (container['screens'] != null) {
          containerScreens = _parseScreens(container['screens']);
        }
      }

      // Parse extend section
      if (theme['extend'] != null) {
        final extend = theme['extend'];

        // Parse colors with HSL support
        if (extend['colors'] != null) {
          final userColors = _parseColorsWithHSL(extend['colors']);
          colors = mergeColors(defaultTailwindColors, userColors);
        }
        if (extend['semanticColors'] != null) {
          final userSemantic = _parseSemanticColors(extend['semanticColors']);
          semanticColors = {...semanticColors, ...userSemantic};
        }

        // Parse border radius with CSS variable support
        if (extend['borderRadius'] != null) {
          final userRadius =
              _parseBorderRadiusWithCSSVar(extend['borderRadius']);
          borderRadius = {...borderRadius, ...userRadius};
        }

        // Parse font sizes with rem support
        if (extend['fontSize'] != null) {
          final userFontSize = _parseFontSizeWithRem(extend['fontSize']);
          fontSize = mergeFontSize(defaultFontSize, userFontSize);
        }

        // Parse font weights
        if (extend['fontWeight'] != null) {
          final userFontWeight = _parseFontWeight(extend['fontWeight']);
          fontWeight = mergeFontWeight(defaultFontWeight, userFontWeight);
        }

        // Parse spacing with rem support
        if (extend['spacing'] != null) {
          final userSpacing = _parseSpacingWithRem(extend['spacing']);
          spacing = mergeSpacing(defaultSpacingScale, userSpacing);
        }

        // Parse box shadows with CSS variable support
        if (extend['boxShadow'] != null) {
          final userShadows = _parseBoxShadowsWithCSSVar(extend['boxShadow']);
          boxShadow = {...boxShadow, ...userShadows};
        }

        // Parse line height
        if (extend['lineHeight'] != null) {
          lineHeight = _parseLineHeight(extend['lineHeight']);
        }

        // Parse letter spacing
        if (extend['letterSpacing'] != null) {
          letterSpacing = _parseLetterSpacing(extend['letterSpacing']);
        }

        // Parse opacity
        if (extend['opacity'] != null) {
          opacity = _parseOpacity(extend['opacity']);
        }

        // Parse z-index
        if (extend['zIndex'] != null) {
          zIndex = _parseZIndex(extend['zIndex']);
        }

        // Parse transition property
        if (extend['transitionProperty'] != null) {
          transitionProperty =
              _parseTransitionProperty(extend['transitionProperty']);
        }

        // Parse transition duration
        if (extend['transitionDuration'] != null) {
          transitionDuration =
              _parseTransitionDuration(extend['transitionDuration']);
        }

        // Parse transition timing function
        if (extend['transitionTimingFunction'] != null) {
          transitionTimingFunction =
              _parseTransitionTimingFunction(extend['transitionTimingFunction']);
        }
      }

      // TokenStore v2 shape:
      // theme:
      //   tokens:
      //     light: { surface: "#fff" }
      //     dark: { surface: "#111827" }
      if (theme['tokens'] != null) {
        _parseThemeTokenSets(theme['tokens']);
      }
    }

    if (yamlMap['colors'] != null) {
      final userColors = _parseColors(yamlMap['colors']);
      colors = mergeColors(defaultTailwindColors, userColors);
    }
    if (yamlMap['semanticColors'] != null) {
      final userSemantic = _parseSemanticColors(yamlMap['semanticColors']);
      semanticColors = {...semanticColors, ...userSemantic};
    }
    if (yamlMap['spacing'] != null) {
      final userSpacing = _parseSpacing(yamlMap['spacing']);
      spacing = mergeSpacing(defaultSpacingScale, userSpacing);
    }
    if (yamlMap['screens'] != null) {
      final userScreens = _parseScreens(yamlMap['screens']);
      screens = mergeScreens(defaultBreakpoints, userScreens);
    }
    if (yamlMap['fontSize'] != null) {
      final userFontSize = _parseFontSize(yamlMap['fontSize']);
      fontSize = mergeFontSize(defaultFontSize, userFontSize);
    }
    if (yamlMap['fontWeight'] != null) {
      final userFontWeight = _parseFontWeight(yamlMap['fontWeight']);
      fontWeight = mergeFontWeight(defaultFontWeight, userFontWeight);
    }
    if (yamlMap['borderWidth'] != null) {
      final userBorderWidth = _parseBorderWidth(yamlMap['borderWidth']);
      borderWidth = {...borderWidth, ...userBorderWidth};
    }

    if (yamlMap['fontFamily'] != null) {
      fontFamily = _parseFontFamily(yamlMap['fontFamily']);
    }
    if (yamlMap['borderRadius'] != null) {
      borderRadius = _parseBorderRadius(yamlMap['borderRadius']);
    }
    if (yamlMap['boxShadow'] != null) {
      boxShadow = _parseBoxShadows(yamlMap['boxShadow']); // Renamed method
    }

    // Parse filter configurations if provided
    if (yamlMap['blur'] != null) {
      blur = _parseBlur(yamlMap['blur']);
    }
    if (yamlMap['brightness'] != null) {
      brightness = _parseBrightness(yamlMap['brightness']);
    }
    if (yamlMap['contrast'] != null) {
      contrast = _parseContrast(yamlMap['contrast']);
    }
    if (yamlMap['dropShadow'] != null) {
      dropShadow = _parseDropShadow(yamlMap['dropShadow']);
    }
  }

  static Map<String, double> _parseScreens(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(data.map((key, value) {
      final parsedValue = value.toString().replaceAll('px', ''); // Remove 'px'
      return MapEntry(key, double.tryParse(parsedValue) ?? 0.0);
    }));
  }

  static Map<String, Color> _parseSemanticColors(dynamic data) {
    if (data == null) return {};
    final parsed = <String, Color>{};
    if (data is Map) {
      data.forEach((key, value) {
        final token = key.toString().trim();
        if (token.isEmpty) return;
        final resolved = _parseColorTokenValue(value);
        if (resolved != null) {
          parsed[token] = resolved;
        }
      });
    }
    return parsed;
  }

  static void _parseThemeTokenSets(dynamic data) {
    if (data is! Map) return;
    final lightRaw = data['light'];
    final darkRaw = data['dark'];

    if (lightRaw is Map) {
      final parsed = _parseSemanticColors(lightRaw);
      semanticColorsLight = {...semanticColorsLight, ...parsed};
      semanticColors = {...semanticColors, ...parsed};
    }
    if (darkRaw is Map) {
      final parsed = _parseSemanticColors(darkRaw);
      semanticColorsDark = {...semanticColorsDark, ...parsed};
    }
  }

  static Color? _parseColorTokenValue(dynamic value) {
    if (value == null) return null;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    if (raw.startsWith('hsl(var(--')) {
      final token = _extractCssVarName(raw);
      return _parseHSLColor(token);
    }
    if (raw.startsWith('#')) {
      return _parseHexColor(raw);
    }
    final colorToken = resolveColorToken(raw);
    if (colorToken != null) return colorToken;
    return null;
  }

  static Color? getSemanticColor(String token, {Brightness? brightness}) {
    final key = token.trim();
    if (key.isEmpty) return null;
    if (brightness == Brightness.dark) {
      final dark = semanticColorsDark[key];
      if (dark != null) return dark;
      final light = semanticColorsLight[key];
      if (light != null) return light;
    } else if (brightness == Brightness.light) {
      final light = semanticColorsLight[key];
      if (light != null) return light;
    }
    return semanticColors[key];
  }

  static double? getSpacing(String token) => spacing[token];

  static double? getFontSize(String token) => fontSize[token];

  static FontWeight? getFontWeight(String token) => fontWeight[token];

  static Color? getColor(String token,
      {int shade = 500, Brightness? brightness}) {
    final trimmed = token.trim();
    if (trimmed.isEmpty) return null;
    final semantic = getSemanticColor(trimmed, brightness: brightness);
    if (semantic != null) return semantic;
    final direct = colors[trimmed]?[shade];
    if (direct != null) return direct;
    return null;
  }

  static Color? resolveColorToken(String token, {Brightness? brightness}) {
    final trimmed = token.trim();
    if (trimmed.isEmpty) return null;

    final semantic = getSemanticColor(trimmed, brightness: brightness);
    if (semantic != null) return semantic;

    // Support scale token like blue-500.
    if (trimmed.contains('-')) {
      final parts = trimmed.split('-');
      if (parts.length >= 2) {
        final maybeShade = int.tryParse(parts.last);
        if (maybeShade != null) {
          final colorName = parts.sublist(0, parts.length - 1).join('-');
          final scaled = colors[colorName]?[maybeShade];
          if (scaled != null) return scaled;
        }
      }
    }

    // Named color token defaults to shade 500.
    final direct = colors[trimmed]?[500];
    if (direct != null) return direct;
    return null;
  }

  static Map<String, Map<int, Color>> _parseColors(dynamic data) {
    if (data == null) return {};
    final Map<String, Map<int, Color>> userColors = {};
    data.forEach((colorName, value) {
      if (value is Map) {
        final Map<int, Color> shadeMap = {};
        value.forEach((shade, hex) {
          shadeMap[int.tryParse(shade.toString()) ?? 500] =
              _parseHexColor(hex.toString());
        });
        userColors[colorName] = shadeMap;
      } else if (value is String) {
        userColors[colorName] = {500: _parseHexColor(value)};
      }
    });

    return userColors;
  }

  static Map<String, double> _parseSpacing(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, List<String>> _parseFontFamily(dynamic data) {
    if (data == null) return {};
    return Map<String, List<String>>.from(data.map((key, value) =>
        MapEntry(key, List<String>.from(value.map((v) => v.toString())))));
  }

  static Map<String, double> _parseFontSize(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, FontWeight> _parseFontWeight(dynamic data) {
    if (data == null) return {};
    return Map<String, FontWeight>.from(
      data.map((key, value) => MapEntry(key, _toFontWeight(value))),
    );
  }

  static FontWeight _toFontWeight(dynamic value) {
    final normalized = value.toString().trim().toLowerCase();

    // Support numeric values as num or string ("700")
    final parsedNumeric = int.tryParse(normalized);
    if (parsedNumeric != null) {
      final clamped = parsedNumeric.clamp(100, 900);
      switch (clamped) {
        case 100:
          return FontWeight.w100;
        case 200:
          return FontWeight.w200;
        case 300:
          return FontWeight.w300;
        case 400:
          return FontWeight.w400;
        case 500:
          return FontWeight.w500;
        case 600:
          return FontWeight.w600;
        case 700:
          return FontWeight.w700;
        case 800:
          return FontWeight.w800;
        case 900:
          return FontWeight.w900;
      }
    }

    // Support named aliases
    switch (normalized) {
      case 'thin':
        return FontWeight.w100;
      case 'extralight':
      case 'extra-light':
        return FontWeight.w200;
      case 'light':
        return FontWeight.w300;
      case 'normal':
      case 'regular':
        return FontWeight.w400;
      case 'medium':
        return FontWeight.w500;
      case 'semibold':
      case 'semi-bold':
        return FontWeight.w600;
      case 'bold':
        return FontWeight.w700;
      case 'extrabold':
      case 'extra-bold':
        return FontWeight.w800;
      case 'black':
        return FontWeight.w900;
      default:
        return FontWeight.w400;
    }
  }

  static Map<String, double> _parseBorderRadius(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, List<BoxShadow>> _parseBoxShadows(dynamic data) {
    if (data == null) return {};
    return Map<String, List<BoxShadow>>.from(data.map((key, value) => MapEntry(
        key, List<BoxShadow>.from(value.map((v) => _createBoxShadow(v))))));
  }

  static Map<String, double> _parseBlur(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, double> _parseBrightness(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, double> _parseContrast(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Map<String, BoxShadow> _parseDropShadow(dynamic data) {
    if (data == null) return {};
    return Map<String, BoxShadow>.from(
        data.map((key, value) => MapEntry(key, _createBoxShadow(value))));
  }

  static Map<String, double> _parseBorderWidth(dynamic data) {
    if (data == null) return {};
    return Map<String, double>.from(
        data.map((key, value) => MapEntry(key, (value as num).toDouble())));
  }

  static Color _parseColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static BoxShadow _createBoxShadow(dynamic data) {
    return BoxShadow(
      color: _parseColor(data['color']),
      offset: Offset((data['offsetX'] as num).toDouble(),
          (data['offsetY'] as num).toDouble()),
      blurRadius: (data['blurRadius'] as num).toDouble(),
      spreadRadius: (data['spreadRadius'] as num).toDouble(),
    );
  }

  static Color _parseHexColor(String hexColor) {
    if (hexColor.isEmpty || !RegExp(r'^[#A-Fa-f0-9]+$').hasMatch(hexColor)) {
      return Colors.transparent; // Fallback to transparent color
    }

    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor'; // Add alpha if missing

    try {
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      Log.e("Error parsing hex color: $hexColor");
      return Colors.transparent;
    }
  }

  static Map<String, Map<int, Color>> mergeColors(
      Map<String, Map<int, Color>> defaults,
      Map<String, Map<int, Color>> user) {
    final merged = Map<String, Map<int, Color>>.from(defaults);
    user.forEach((key, value) {
      if (merged.containsKey(key)) {
        merged[key] = {...merged[key]!, ...value};
      } else {
        merged[key] = value;
      }
    });
    return merged;
  }

  static Map<String, double> mergeFontSize(
      Map<String, double> defaults, Map<String, double> user) {
    return {...defaults, ...user};
  }

  static Map<String, FontWeight> mergeFontWeight(
      Map<String, FontWeight> defaults, Map<String, FontWeight> user) {
    return {...defaults, ...user}; // Properly merges user-defined values
  }

  static Map<String, double> mergeSpacing(
      Map<String, double> defaults, Map<String, double> user) {
    return {...defaults, ...user}; // Properly merges user-defined values
  }

  static Map<String, double> mergeScreens(
      Map<String, double> defaults, Map<String, double> user) {
    return {...defaults, ...user}; // Properly merges user-defined values
  }

  // Helper methods for parsing shadcn-specific configurations
  static Map<String, dynamic> _parseAnimations(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseKeyframes(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseRingOffsetWidth(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseRingOffsetColor(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseRingWidth(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseRingColor(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseRotate(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseScale(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseTranslate(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, dynamic> _parseSkew(dynamic data) {
    if (data == null) return {};
    return Map<String, dynamic>.from(data);
  }

  static Map<String, double> _parseOpacity(dynamic data) {
    if (data == null) return {};
    final Map<String, double> parsed = {};
    data.forEach((key, value) {
      final normalizedKey = key.toString();
      if (value is String) {
        final normalizedValue = value.replaceAll('%', '').trim();
        final parsedValue = double.tryParse(normalizedValue) ?? 0.0;
        parsed[normalizedKey] =
            parsedValue > 1.0 ? parsedValue / 100.0 : parsedValue;
      } else if (value is num) {
        final parsedValue = value.toDouble();
        parsed[normalizedKey] =
            parsedValue > 1.0 ? parsedValue / 100.0 : parsedValue;
      }
    });
    return parsed;
  }

  static Map<String, int> _parseZIndex(dynamic data) {
    if (data == null) return {};
    final Map<String, int> parsed = {};
    data.forEach((key, value) {
      final normalizedKey = key.toString();
      if (value is String) {
        if (value == 'auto') {
          parsed[normalizedKey] = -1;
        } else {
          parsed[normalizedKey] = int.tryParse(value) ?? 0;
        }
      } else if (value is num) {
        parsed[normalizedKey] = value.toInt();
      }
    });
    return parsed;
  }

  // Updated parsing methods with CSS variable and rem support
  static Map<String, Map<int, Color>> _parseColorsWithHSL(dynamic data) {
    if (data == null) return {};
    final Map<String, Map<int, Color>> userColors = {};
    data.forEach((colorName, value) {
      if (value is Map) {
        final Map<int, Color> shadeMap = {};
        value.forEach((shade, colorValue) {
          if (colorValue is String && colorValue.startsWith('hsl(var(--')) {
            // Handle HSL CSS variables
            final colorName = _extractCssVarName(colorValue);
            shadeMap[int.tryParse(shade.toString()) ?? 500] =
                _parseHSLColor(colorName);
          } else {
            shadeMap[int.tryParse(shade.toString()) ?? 500] =
                _parseHexColor(colorValue.toString());
          }
        });
        userColors[colorName] = shadeMap;
      } else if (value is String) {
        if (value.startsWith('hsl(var(--')) {
          final colorName = _extractCssVarName(value);
          userColors[colorName] = {500: _parseHSLColor(colorName)};
        } else {
          userColors[colorName] = {500: _parseHexColor(value)};
        }
      }
    });
    return userColors;
  }

  static Map<String, double> _parseBorderRadiusWithCSSVar(dynamic data) {
    if (data == null) return {};
    final Map<String, double> parsedRadius = {};
    data.forEach((key, value) {
      if (value is String) {
        if (value.startsWith('var(--radius)')) {
          parsedRadius[key.toString()] = 6.0; // Default radius
        } else if (value.startsWith('calc(var(--radius)')) {
          final offset =
              double.tryParse(value.split('-')[1].split(')')[0]) ?? 0;
          parsedRadius[key.toString()] = 6.0 - offset; // Radius with offset
        } else {
          parsedRadius[key.toString()] = _parseLengthToPx(value);
        }
      }
    });
    return parsedRadius;
  }

  static Map<String, double> _parseFontSizeWithRem(dynamic data) {
    if (data == null) return {};
    final Map<String, double> parsedFontSize = {};
    data.forEach((key, value) {
      if (value is List && value.length >= 1) {
        final size = _parseLengthToPx(value[0].toString());
        parsedFontSize[key.toString()] = size;
      }
    });
    return parsedFontSize;
  }

  static Map<String, double> _parseSpacingWithRem(dynamic data) {
    if (data == null) return {};
    final Map<String, double> parsedSpacing = {};
    data.forEach((key, value) {
      if (value is String) {
        final size = _parseLengthToPx(value);
        parsedSpacing[key.toString()] = size;
      } else if (value is num) {
        parsedSpacing[key.toString()] = value.toDouble();
      }
    });
    return parsedSpacing;
  }

  static double _parseLengthToPx(String rawValue) {
    final value = rawValue.trim().toLowerCase();
    if (value.endsWith('rem')) {
      final rem = double.tryParse(value.replaceAll('rem', '')) ?? 0.0;
      return rem * 16.0;
    }
    if (value.endsWith('px')) {
      return double.tryParse(value.replaceAll('px', '')) ?? 0.0;
    }
    return double.tryParse(value) ?? 0.0;
  }

  static Map<String, List<BoxShadow>> _parseBoxShadowsWithCSSVar(dynamic data) {
    if (data == null) return {};
    final Map<String, List<BoxShadow>> parsedShadows = {};
    data.forEach((key, value) {
      if (value is String) {
        if (value.startsWith('var(--')) {
          // Handle CSS variable shadows
          parsedShadows[key] = [_parseCSSVarShadow(value)];
        } else {
          parsedShadows[key] = [_parseBoxShadow(value)];
        }
      }
    });
    return parsedShadows;
  }

  static BoxShadow _parseCSSVarShadow(String cssVar) {
    // Placeholder for CSS variable shadow parsing
    return BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow _parseBoxShadow(dynamic data) {
    if (data is String) {
      // Handle string-based shadow definitions
      return BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      );
    } else if (data is Map) {
      // Handle map-based shadow definitions
      return BoxShadow(
        color: _parseHexColor(data['color']?.toString() ?? '#000000'),
        blurRadius: (data['blurRadius'] as num?)?.toDouble() ?? 4.0,
        offset: Offset(
          (data['offsetX'] as num?)?.toDouble() ?? 0.0,
          (data['offsetY'] as num?)?.toDouble() ?? 2.0,
        ),
        spreadRadius: (data['spreadRadius'] as num?)?.toDouble() ?? 0.0,
      );
    }
    // Default shadow
    return BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }

  static Color _parseHSLColor(String colorName) {
    // Extract the color name from the CSS variable
    // Example: --primary -> primary
    final name = colorName.replaceAll('--', '');

    // Default color values for shadcn's color system
    final defaultColors = {
      'background': _hsl(0, 0, 100), // White
      'foreground': _hsl(222.2, 84, 4.9), // Dark gray
      'card': _hsl(0, 0, 100), // White
      'card-foreground': _hsl(222.2, 84, 4.9), // Dark gray
      'popover': _hsl(0, 0, 100), // White
      'popover-foreground': _hsl(222.2, 84, 4.9), // Dark gray
      'primary': _hsl(222.2, 47.4, 11.2), // Dark blue
      'primary-foreground': _hsl(210, 40, 98), // Light blue
      'secondary': _hsl(210, 40, 96.1), // Light gray
      'secondary-foreground': _hsl(222.2, 47.4, 11.2), // Dark blue
      'muted': _hsl(210, 40, 96.1), // Light gray
      'muted-foreground': _hsl(215.4, 16.3, 46.9), // Medium gray
      'accent': _hsl(210, 40, 96.1), // Light gray
      'accent-foreground': _hsl(222.2, 47.4, 11.2), // Dark blue
      'destructive': _hsl(0, 84.2, 60.2), // Red
      'destructive-foreground': _hsl(210, 40, 98), // Light blue
      'border': _hsl(214.3, 31.8, 91.4), // Light gray
      'input': _hsl(214.3, 31.8, 91.4), // Light gray
      'ring': _hsl(222.2, 84, 4.9), // Dark gray
    };

    // Return the default color if found, otherwise return a fallback color
    return defaultColors[name]?.toColor() ?? Colors.blue;
  }

  static String _extractCssVarName(String value) {
    final match = RegExp(r'hsl\(var\(--([^)]+)\)\)').firstMatch(value);
    if (match != null) {
      return match.group(1) ?? value;
    }
    final cleaned = value
        .replaceAll('hsl(var(--', '')
        .replaceAll('))', '')
        .replaceAll(')', '')
        .trim();
    return cleaned;
  }

  static HSLColor _hsl(double hue, double saturation, double lightness,
      [double alpha = 1.0]) {
    final normalizedHue = ((hue % 360) + 360) % 360;
    final normalizedSaturation =
        (saturation > 1 ? saturation / 100.0 : saturation).clamp(0.0, 1.0);
    final normalizedLightness =
        (lightness > 1 ? lightness / 100.0 : lightness).clamp(0.0, 1.0);
    final normalizedAlpha = alpha.clamp(0.0, 1.0);

    return HSLColor.fromAHSL(
      normalizedAlpha,
      normalizedHue,
      normalizedSaturation,
      normalizedLightness,
    );
  }

  // New parsing methods for additional configurations
  static Map<String, double> _parseLineHeight(dynamic data) {
    if (data == null) return {};
    final Map<String, double> parsed = {};
    data.forEach((key, value) {
      final normalizedKey = key.toString();
      if (value is String) {
        parsed[normalizedKey] = double.tryParse(value) ?? 1.0;
      } else if (value is num) {
        parsed[normalizedKey] = value.toDouble();
      }
    });
    return parsed;
  }

  static Map<String, double> _parseLetterSpacing(dynamic data) {
    if (data == null) return {};
    final Map<String, double> parsed = {};
    data.forEach((key, value) {
      final normalizedKey = key.toString();
      if (value is String) {
        parsed[normalizedKey] =
            double.tryParse(value.replaceAll('em', '')) ?? 0.0;
      } else if (value is num) {
        parsed[normalizedKey] = value.toDouble();
      }
    });
    return parsed;
  }

  static Map<String, List<String>> _parseTransitionProperty(dynamic data) {
    if (data == null) return {};
    final Map<String, List<String>> parsed = {};
    data.forEach((key, value) {
      final normalizedKey = key.toString();
      if (value is String) {
        parsed[normalizedKey] = value.split(',').map((e) => e.trim()).toList();
      } else if (value is List) {
        parsed[normalizedKey] = value.map((e) => e.toString()).toList();
      }
    });
    return parsed;
  }

  static Map<String, Duration> _parseTransitionDuration(dynamic data) {
    if (data == null) return {};
    final Map<String, Duration> parsed = {};
    data.forEach((key, value) {
      final normalizedKey = key.toString();
      if (value is String) {
        final ms = int.tryParse(value.replaceAll('ms', '')) ?? 0;
        parsed[normalizedKey] = Duration(milliseconds: ms);
      } else if (value is num) {
        parsed[normalizedKey] = Duration(milliseconds: value.toInt());
      }
    });
    return parsed;
  }

  static Map<String, Curve> _parseTransitionTimingFunction(dynamic data) {
    if (data == null) return {};
    final Map<String, Curve> parsed = {};
    data.forEach((key, value) {
      final normalizedKey = key.toString();
      if (value is String) {
        switch (value) {
          case 'linear':
            parsed[normalizedKey] = Curves.linear;
            break;
          case 'in':
            parsed[normalizedKey] = Curves.easeIn;
            break;
          case 'out':
            parsed[normalizedKey] = Curves.easeOut;
            break;
          case 'in-out':
            parsed[normalizedKey] = Curves.easeInOut;
            break;
          default:
            parsed[normalizedKey] = Curves.easeInOut;
        }
      }
    });
    return parsed;
  }
}
