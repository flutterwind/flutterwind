import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/classes/animation_presets.dart';
import 'package:flutterwind_core/src/classes/animations.dart';
import 'package:flutterwind_core/src/classes/aspect_ratio.dart';
import 'package:flutterwind_core/src/classes/filter_effects.dart';
import 'package:flutterwind_core/src/classes/input.dart';
import 'package:flutterwind_core/src/classes/text_effects.dart';
import 'package:flutterwind_core/src/widgets/ring_painter.dart';
import 'package:flutterwind_core/src/classes/transform_utils.dart';
import 'package:flutterwind_core/src/classes/position.dart';
import 'package:flutterwind_core/src/classes/sizing.dart';
import 'package:flutterwind_core/src/classes/spacings.dart';
import 'package:flutterwind_core/src/classes/colors.dart';
import 'package:flutterwind_core/src/classes/typography.dart';
import 'package:flutterwind_core/src/classes/borders.dart';
import 'package:flutterwind_core/src/classes/opacity.dart';
import 'package:flutterwind_core/src/classes/shadows.dart';
import 'package:flutterwind_core/src/classes/background.dart';
import 'package:flutterwind_core/src/classes/accessibility.dart';
import 'package:flutterwind_core/src/classes/performance.dart';
import 'package:flutterwind_core/src/plugin/class_handler.dart';
import 'package:flutterwind_core/src/plugin/class_handler_registry.dart';
import 'package:flutterwind_core/src/presets/component_presets.dart';
import 'package:flutterwind_core/src/widgets/performance_widgets.dart';

String mergeClasses(List<String?> classes) {
  return classes
      .whereType<String>()
      .where((c) => c.trim().isNotEmpty)
      .join(' ');
}

class FlutterWindStyle {
  EdgeInsets? padding;
  EdgeInsets? margin;
  Color? backgroundColor;
  double? textSize;
  Color? textColor;
  FontWeight? fontWeight;
  BorderRadius? borderRadius;
  Color? borderColor;
  double? borderWidth;
  Border? border; // For directional border control
  double? opacity;
  List<BoxShadow>? boxShadows;
  TextAlign? textAlign;
  // Typography properties
  TextDecoration? textDecoration;
  TextStyle? textStyle;
  String? textTransform;
  FontFeature? fontVariantNumeric;
  String? listStyleType;
  double? textIndent;
  List<Shadow>? textShadows;
  double? letterSpacing;
  double? wordSpacing;
  double? lineHeight;
  TextOverflow? textOverflow;
  bool? textWrap;
  TextSelectionBehavior? textSelection;
  double? textScale;
  TextDirection? textDirection;

  // New sizing properties:
  double? width; // Fixed width in pixels
  double? height; // Fixed height in pixels
  double? widthFactor; // Relative width (e.g. 0.5 for 50%)
  double? heightFactor; // Relative height
  double? minWidth; // Minimum width constraint
  double? minHeight; // Minimum height constraint
  double? maxWidth; // Maximum width constraint
  double? maxHeight; // Maximum height constraint

  // NEW: Overflow handling
  bool? overFlowScroll;
  bool? overFlowHidden;
  Axis? overFlowScrollAxis;

  // NEW: Inset shadows (not directly supported by Flutter's BoxShadow)
  List<BoxShadow>? insetBoxShadows;

  // Ring properties – for focus outlines etc.
  BoxShadow? ringShadow;
  Color? ringColor;
  double? ringWidth;
  Color? ringOffsetColor;
  double? ringOffsetWidth;

  MainAxisAlignment? mainAxisAlignment;
  CrossAxisAlignment? crossAxisAlignment;

  // Gesture properties:
  VoidCallback? onTap;
  VoidCallback? onDoubleTap;
  VoidCallback? onLongPress;

  //Animation
  Duration? transitionDuration;
  Duration? transitionDelay;
  Curve? transitionCurve;
  int? animationIterationCount;
  AnimationDirection? animationDirection;
  AnimationFillMode? animationFillMode;
  Map<double, Map<String, dynamic>>? animationKeyframes;
  AnimationPreset? animationPreset;

  // Add aspect ratio property
  double? aspectRatio;

  // Position properties
  PositionType? position;
  double? insetTop;
  double? insetRight;
  double? insetBottom;
  double? insetLeft;

  // Filter and effects properties
  ImageFilter? imageFilter; // For blur effects
  ImageFilter? backdropFilter; // For backdrop blur
  bool useBackdropFilter = false; // Flag to enable backdrop filter
  ColorFilter? colorFilter; // For brightness/contrast
  BoxShadow? dropShadow; // For drop shadow effect

  // Transform properties
  Matrix4? transform; // For all transform operations
  Alignment transformAlignment = Alignment.center; // Transform origin
  double? translateXFactor; // For percentage-based X translations
  double? translateYFactor; // For percentage-based Y translations

  // Gradient properties
  List<Color>? gradientColors;
  List<double>? gradientStops;
  Gradient? gradient;

  // Background properties
  BoxFit? backgroundFit;
  Alignment? backgroundAlignment;
  BlendMode? backgroundBlendMode;
  ImageRepeat? backgroundRepeat;
  String? backgroundAttachment; // 'fixed', 'local', 'scroll'
  String? backgroundOrigin; // 'border', 'padding', 'content'
  BoxShape? backgroundClip;
  double? backgroundOpacity;

  // Accessibility properties - keep only essential ones
  String? semanticsLabel;
  bool? focusable;
  int? focusOrder;
  bool? screenReaderOnly;
  bool? liveRegion;

  // Performance properties
  bool? lazyLoad;
  bool? cache;
  bool? memoryOptimization;
  String? imageOptimization;
  bool? widgetRecycling;
  int? debounce;
  int? throttle;

  // Input properties
  InputBorder? inputBorder;
  EdgeInsets? inputPadding;
  double? inputFontSize;
  Color? inputFocusColor;
  double? inputFocusWidth;
  Color? inputFocusBorderColor;
  Color? inputHoverBorderColor;
  Color? inputHoverBackgroundColor;
  double? inputDisabledOpacity;
  Color? inputDisabledBackgroundColor;

  // Helper method for list style markers
  String _getListStyleMarker(String listStyleType) {
    switch (listStyleType) {
      case 'disc':
        return '•';
      case 'circle':
        return '○';
      case 'square':
        return '■';
      case 'decimal':
        return '1.';
      case 'roman':
        return 'I.';
      case 'alpha':
        return 'a.';
      default:
        return '•';
    }
  }

  Widget build(Widget child) {
    Widget current = child;

    // Apply animation properties if specified
    if (transitionDuration != null ||
        transitionDelay != null ||
        transitionCurve != null ||
        animationIterationCount != null ||
        animationDirection != null ||
        animationFillMode != null ||
        animationKeyframes != null ||
        animationPreset != null) {
      if (animationPreset != null) {
        current = AnimationPresets.applyAnimationWidget(
          current,
          animationPreset!,
          transitionDuration ?? const Duration(milliseconds: 1000),
          transitionCurve ?? Curves.linear,
        );
      } else {
        current = AnimatedContainer(
          duration: transitionDuration ?? Duration.zero,
          curve: transitionCurve ?? Curves.linear,
          child: current,
        );
      }
    }

    // Apply background properties if specified
    if (backgroundFit != null ||
        backgroundAlignment != null ||
        backgroundBlendMode != null ||
        backgroundRepeat != null ||
        backgroundClip != null ||
        backgroundOpacity != null) {
      current = Container(
        decoration: BoxDecoration(
          shape: backgroundClip ?? BoxShape.rectangle,
          // Background image utilities require an image source, which is not
          // represented by current class syntax. Avoid invalid placeholders.
        ),
        child: current,
      );

      if (backgroundBlendMode != null || backgroundOpacity != null) {
        current = ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.white.withValues(alpha: backgroundOpacity ?? 1.0),
            backgroundBlendMode ?? BlendMode.srcOver,
          ),
          child: current,
        );
      }
    }

    // Apply image filter (blur) if specified
    if (imageFilter != null) {
      current = ImageFiltered(
        imageFilter: imageFilter!,
        child: current,
      );
    }

    // Apply typography features
    final hasTextStyles = textColor != null ||
        textSize != null ||
        fontWeight != null ||
        letterSpacing != null ||
        wordSpacing != null ||
        lineHeight != null ||
        textShadows != null ||
        textDecoration != null ||
        fontVariantNumeric != null;

    if (hasTextStyles || textTransform != null || textIndent != null) {
      final textStyle = TextStyle(
        color: textColor,
        fontSize: textSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: lineHeight,
        shadows: textShadows,
        decoration: textDecoration,
        fontFeatures: fontVariantNumeric != null ? [fontVariantNumeric!] : null,
      );

      if (current is Text) {
        final textWidget = current;
        var content = textWidget.data ?? '';
        if (textTransform != null) {
          content = _applyTextTransform(content, textTransform!);
        }

        current = Text(
          content,
          style: textWidget.style?.copyWith(
                color: textColor,
                fontSize: textSize,
                fontWeight: fontWeight,
                letterSpacing: letterSpacing,
                wordSpacing: wordSpacing,
                height: lineHeight,
                shadows: textShadows,
                decoration: textDecoration,
                fontFeatures:
                    fontVariantNumeric != null ? [fontVariantNumeric!] : null,
              ) ??
              textStyle,
          textAlign: textWidget.textAlign ?? textAlign,
          maxLines: textWidget.maxLines,
          overflow: textWidget.overflow,
          softWrap: textWidget.softWrap,
        );
      } else if (hasTextStyles) {
        current = DefaultTextStyle.merge(
          style: textStyle,
          textAlign: textAlign,
          child: current,
        );
      }

      // Apply text indent
      if (textIndent != null) {
        current = Padding(
          padding: EdgeInsets.only(left: textIndent!),
          child: current,
        );
      }

      // Apply list style
      if (listStyleType != null && listStyleType != 'none') {
        // This is a simplified implementation as Flutter doesn't have direct list style support
        // For a complete implementation, a custom widget would be needed
        current = Builder(
          builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    _getListStyleMarker(listStyleType!),
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
                Expanded(child: current),
              ],
            );
          },
        );
      }
    }

    // Apply color filter (brightness/contrast) if specified
    if (colorFilter != null) {
      current = ColorFiltered(
        colorFilter: colorFilter!,
        child: current,
      );
    }

    // Apply aspect ratio before external sizing wrappers are added.
    // This allows width/height constraints applied below to bound AspectRatio.
    if (aspectRatio != null) {
      current = AspectRatio(
        aspectRatio: aspectRatio!,
        child: current,
      );
    }

    if (widthFactor != null || heightFactor != null) {
      current = FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: current,
      );
    } else if (width != null || height != null) {
      current = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width ?? 0,
          maxWidth: width ?? double.infinity,
          minHeight: height ?? 0,
          maxHeight: height ?? double.infinity,
        ),
        child: current,
      );
    }

    if (overFlowScroll == true) {
      current = SingleChildScrollView(
        scrollDirection: overFlowScrollAxis ?? Axis.vertical,
        clipBehavior: overFlowHidden == true ? Clip.hardEdge : Clip.none,
        physics: const BouncingScrollPhysics(),
        child: current,
      );
    }

    // Apply animation preset if specified
    if (animationPreset != null) {
      current = AnimationPresets.applyAnimationWidget(
        current,
        animationPreset!,
        transitionDuration ?? const Duration(milliseconds: 1000),
        transitionCurve ?? Curves.linear,
      );
    }

    // TODO: Add support for positioned using stack
    // Apply positioning if specified
    if (position != null) {
      switch (position) {
        case PositionType.absolute:
          current = Positioned(
            top: insetTop,
            right: insetRight,
            bottom: insetBottom,
            left: insetLeft,
            child: current,
          );
          break;
        case PositionType.fixed:
          // In Flutter, fixed position is similar to absolute within a Stack
          current = Positioned(
            top: insetTop,
            right: insetRight,
            bottom: insetBottom,
            left: insetLeft,
            child: current,
          );
          break;
        case PositionType.sticky:
          // Sticky is not directly supported in Flutter, but we can approximate
          // with a combination of positioning and scroll listeners in a custom widget
          // For now, treat it like absolute
          current = Positioned(
            top: insetTop,
            right: insetRight,
            bottom: insetBottom,
            left: insetLeft,
            child: current,
          );
          break;
        case PositionType.relative:
          if (insetTop != null ||
              insetRight != null ||
              insetBottom != null ||
              insetLeft != null) {
            current = Padding(
              padding: EdgeInsets.only(
                top: insetTop ?? 0,
                right: insetRight ?? 0,
                bottom: insetBottom ?? 0,
                left: insetLeft ?? 0,
              ),
              child: current,
            );
          }
          break;
        default:
          break;
      }
    }

    // Handle opacity wrapper
    if (opacity != null) {
      current = Opacity(opacity: opacity!, child: current);
    }

    // Apply backdrop filter if specified
    if (useBackdropFilter && backdropFilter != null) {
      current = ClipRect(
        child: BackdropFilter(
          filter: backdropFilter!,
          child: current,
        ),
      );
    }

    // Apply transforms if specified
    if (transform != null) {
      // Apply percentage-based translations if needed
      if (translateXFactor != null || translateYFactor != null) {
        // We'll need to wrap in a LayoutBuilder to get the parent size
        current = LayoutBuilder(
          builder: (context, constraints) {
            final Matrix4 translationMatrix = Matrix4.identity();
            if (translateXFactor != null) {
              translationMatrix
                  .translate(constraints.maxWidth * translateXFactor!);
            }
            if (translateYFactor != null) {
              translationMatrix.translate(
                  0, constraints.maxHeight * translateYFactor!);
            }

            // Combine with existing transform
            final Matrix4 combinedTransform = transform!.clone();
            combinedTransform.multiply(translationMatrix);

            return Transform(
              transform: combinedTransform,
              alignment: transformAlignment,
              child: current,
            );
          },
        );
      } else {
        current = Transform(
          transform: transform!,
          alignment: transformAlignment,
          child: current,
        );
      }
    }

    // Apply drop shadow if specified
    if (dropShadow != null) {
      current = Container(
        decoration: BoxDecoration(
          boxShadow: [dropShadow!],
        ),
        child: current,
      );
    }

    // Handle main container styling with animation support
    final hasContainerStyles = padding != null ||
        margin != null ||
        backgroundColor != null ||
        borderRadius != null ||
        boxShadows != null;

    if (hasContainerStyles) {
      current = transitionDuration != null
          ? AnimatedContainer(
              duration: transitionDuration!,
              curve: transitionCurve ?? Curves.easeInOut,
              padding: padding,
              margin: margin,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
                border: border ??
                    (borderWidth != null || borderColor != null
                        ? Border.all(
                            color: borderColor ?? const Color(0xFFE5E7EB),
                            width: borderWidth ?? 0.0,
                          )
                        : null),
                boxShadow: boxShadows,
              ),
              child: current,
            )
          : Container(
              padding: padding,
              margin: margin,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
                border: border ??
                    (borderWidth != null || borderColor != null
                        ? Border.all(
                            color: borderColor ?? const Color(0xFFE5E7EB),
                            width: borderWidth ?? 0.0,
                          )
                        : null),
                boxShadow: boxShadows,
              ),
              child: current,
            );
    }

    if (insetBoxShadows != null) {
      // Here we simply store them; you might later use them in a custom widget.
      // For now, we leave them as a property on the style.
    }

    // ALWAYS wrap Container with CustomPaint so the widget tree structure
    // never changes when ring classes are toggled (e.g. focus:ring-*).
    // When no ring is active, it paints transparent with 0 radius (no-op).
    // This prevents TextField from being remounted and losing focus.
    if (current is Container) {
      final container = current as Container;
      final existingDecoration = container.decoration as BoxDecoration? ?? const BoxDecoration();
      
      final borderRadius = existingDecoration.borderRadius as BorderRadius?;
      final borderRadiusValue = borderRadius?.topLeft.x ?? 0.0;
      
      final hasRing = ringShadow != null || ringColor != null || ringWidth != null;
      
      current = CustomPaint(
        painter: RingPainter(
          glowColor: hasRing ? (ringColor ?? Colors.transparent) : Colors.transparent,
          glowRadius: hasRing ? (ringWidth ?? 3.0) : 0.0,
          borderRadius: borderRadiusValue,
          offsetWidth: hasRing ? (ringOffsetWidth ?? 0.0) : 0.0,
          offsetColor: hasRing ? (ringOffsetColor ?? Colors.white) : Colors.white,
        ),
        child: Container(
          alignment: container.alignment,
          padding: container.padding,
          margin: container.margin,
          clipBehavior: Clip.none,
          transform: container.transform,
          transformAlignment: container.transformAlignment,
          foregroundDecoration: container.foregroundDecoration,
          constraints: container.constraints,
          decoration: existingDecoration,
          child: container.child,
        ),
      );
    }

    if (onTap != null || onDoubleTap != null) {
      current = GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: current,
      );
    }

    // Apply gradient if specified
    if (gradient != null) {
      current = Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: current,
      );
    }

    // Apply performance optimizations if specified
    if (lazyLoad == true ||
        cache == true ||
        memoryOptimization == true ||
        imageOptimization != null ||
        widgetRecycling == true ||
        debounce != null ||
        throttle != null) {
      Widget optimizedChild = current;

      // Apply lazy loading
      if (lazyLoad == true) {
        optimizedChild = LazyLoadWrapper(
          key: ValueKey('lazy-load-${DateTime.now().millisecondsSinceEpoch}'),
          child: optimizedChild,
        );
      }

      // Apply caching
      if (cache == true) {
        optimizedChild = Cache(
          child: optimizedChild,
        );
      }

      // Apply memory optimization
      if (memoryOptimization == true) {
        optimizedChild = MemoryOptimized(
          child: optimizedChild,
        );
      }

      // Apply image optimization
      if (imageOptimization != null) {
        optimizedChild = ImageOptimized(
          optimizationMode: imageOptimization!,
          child: optimizedChild,
        );
      }

      // Apply widget recycling
      if (widgetRecycling == true) {
        optimizedChild = RecycledWidget(
          child: optimizedChild,
        );
      }

      // Apply debounce
      if (debounce != null) {
        optimizedChild = Debounced(
          duration: Duration(milliseconds: debounce!),
          child: optimizedChild,
        );
      }

      // Apply throttle
      if (throttle != null) {
        optimizedChild = Throttled(
          duration: Duration(milliseconds: throttle!),
          child: optimizedChild,
        );
      }

      current = Builder(
        builder: (context) {
          return optimizedChild;
        },
      );
    }

    if (focusOrder != null) {
      current = FocusTraversalOrder(
        order: NumericFocusOrder(focusOrder!.toDouble()),
        child: current,
      );
    }

    if (focusable != null) {
      current = Focus(
        canRequestFocus: focusable!,
        descendantsAreFocusable: focusable!,
        child: current,
      );
    }

    if (screenReaderOnly == true) {
      current = Semantics(
        label: semanticsLabel,
        liveRegion: liveRegion == true,
        child: const SizedBox.shrink(),
      );
      return current;
    }

    if (semanticsLabel != null || liveRegion == true) {
      current = Semantics(
        label: semanticsLabel,
        liveRegion: liveRegion == true,
        child: current,
      );
    }

    return current;
  }
}

enum _VariantState { hover, focus, focusVisible, active, disabled, ariaInvalid }

const List<String> kFlutterWindSupportedVariants = <String>[
  'dark',
  'light',
  'hover',
  'focus',
  'focus-visible',
  'active',
  'input-hover',
  'input-focus',
  'input-focus-visible',
  'input-active',
  'group-hover',
  'group-focus',
  'group-active',
  'peer-hover',
  'peer-focus',
  'peer-active',
  'peer-disabled',
  'disabled',
  'input-disabled',
  'aria-invalid',
  'placeholder',
];

const List<String> kFlutterWindSupportedUtilityPrefixes = <String>[
  'font-',
  'p-',
  'pt-',
  'pb-',
  'pl-',
  'pr-',
  'px-',
  'py-',
  'ps-',
  'pe-',
  'm-',
  'mt-',
  'mb-',
  'ml-',
  'mr-',
  'mx-',
  'my-',
  'ms-',
  'me-',
  'flex',
  'flex-',
  'grid',
  'grid-',
  'gap-',
  'space-x-',
  'space-y-',
  'justify-',
  'items-',
  'content-',
  'grow-',
  'shrink-',
  'basis-',
  'auto-flow-',
  'col-span-',
  'bg-',
  'text-',
  'input-',
  'tracking-',
  'word-spacing-',
  'leading-',
  'from-',
  'via-',
  'to-',
  'rounded',
  'opacity-',
  'shadow',
  'w-',
  'h-',
  'min-w-',
  'min-h-',
  'max-w-',
  'max-h-',
  'size-',
  'overflow-',
  'aspect-',
  'animate-',
  'transition-',
  'duration-',
  'delay-',
  'ease-',
  'top-',
  'right-',
  'bottom-',
  'left-',
  'inset-',
  'scale-',
  'rotate-',
  'translate-',
  'skew-',
  'origin-',
  'blur-',
  'backdrop-blur-',
  'backdrop-filter',
  'blend-',
  'shader-',
  'brightness-',
  'contrast-',
  'drop-shadow',
  'sr-only',
  'focusable',
  'focus-order-',
  'lazy-load',
  'cache',
  'memory-optimize',
  'optimize-memory',
  'no-optimize-memory',
  'image-optimize-',
  'widget-recycle',
  'debounce-',
  'throttle-',
  'btn-',
  'card-',
  'border',
  'ring',
  'ring-',
  'ring-offset-',
  'underline-offset-',
];

const Set<String> kFlutterWindSupportedExactUtilities = <String>{
  'underline',
  'line-through',
  'overline',
  'no-underline',
  'uppercase',
  'lowercase',
  'capitalize',
  'normal-case',
  'select-none',
  'select-text',
  'select-all',
  'rtl',
  'ltr',
  'focus-first',
  'focus-last',
  'text-wrap',
  'aria-live',
  'outline',
  'outline-none',
  'group',
  'peer',
  'btn',
  'card',
  'card-header',
  'card-body',
  'input-filled',
  'inline-flex',
  'whitespace-nowrap',
};

enum FlutterWindDiagnosticSeverity { info, warning, error }

class FlutterWindDiagnostic {
  final FlutterWindDiagnosticSeverity severity;
  final String code;
  final String message;
  final String token;
  final List<String> suggestions;
  final DateTime timestamp;

  const FlutterWindDiagnostic({
    required this.severity,
    required this.code,
    required this.message,
    required this.token,
    this.suggestions = const <String>[],
    required this.timestamp,
  });
}

class FlutterWindDiagnosticsCollector {
  final List<FlutterWindDiagnostic> _diagnostics = <FlutterWindDiagnostic>[];

  List<FlutterWindDiagnostic> get diagnostics =>
      List<FlutterWindDiagnostic>.unmodifiable(_diagnostics);

  void clear() {
    _diagnostics.clear();
  }

  void add(FlutterWindDiagnostic diagnostic) {
    _diagnostics.add(diagnostic);
    flutterWindDiagnosticsNotifier.value = diagnostics;
  }
}

final ValueNotifier<List<FlutterWindDiagnostic>> flutterWindDiagnosticsNotifier =
    ValueNotifier<List<FlutterWindDiagnostic>>(<FlutterWindDiagnostic>[]);

List<String> suggestFlutterWindUtilities(String utility, {int maxResults = 3}) {
  final query = utility.trim();
  if (query.isEmpty) return const <String>[];
  final candidates = <String>[
    ...kFlutterWindSupportedExactUtilities,
    ...kFlutterWindSupportedUtilityPrefixes,
  ];
  return _nearestMatches(query, candidates, maxResults: maxResults);
}

List<String> suggestFlutterWindVariants(String variant, {int maxResults = 3}) {
  final query = variant.trim();
  if (query.isEmpty) return const <String>[];
  final candidates = <String>[
    ...kFlutterWindSupportedVariants,
    ...TailwindConfig.screens.keys,
  ];
  return _nearestMatches(query, candidates, maxResults: maxResults);
}

List<String> _nearestMatches(String query, List<String> candidates,
    {int maxResults = 3}) {
  final normalizedQuery = query.toLowerCase();
  final scored = <MapEntry<String, int>>[];
  final seen = <String>{};
  for (final candidate in candidates) {
    final key = candidate.toLowerCase();
    if (!seen.add(key)) continue;
    scored.add(MapEntry(candidate, _levenshteinDistance(normalizedQuery, key)));
  }
  scored.sort((a, b) {
    final distanceCompare = a.value.compareTo(b.value);
    if (distanceCompare != 0) return distanceCompare;
    return a.key.compareTo(b.key);
  });
  return scored
      .where((entry) => entry.value <= (query.length > 8 ? 5 : 3))
      .take(maxResults)
      .map((e) => e.key)
      .toList();
}

int _levenshteinDistance(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  final previous = List<int>.generate(b.length + 1, (i) => i);
  final current = List<int>.filled(b.length + 1, 0);
  for (var i = 1; i <= a.length; i++) {
    current[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final substitutionCost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      current[j] = [
        current[j - 1] + 1,
        previous[j] + 1,
        previous[j - 1] + substitutionCost,
      ].reduce((min, value) => value < min ? value : min);
    }
    for (var j = 0; j <= b.length; j++) {
      previous[j] = current[j];
    }
  }
  return previous[b.length];
}

class _ParsedClassToken {
  final List<String> variants;
  final String utility;

  const _ParsedClassToken({
    required this.variants,
    required this.utility,
  });
}

class _ConditionalUtility {
  final Set<_VariantState> requiredStates;
  final Set<_VariantState> requiredGroupStates;
  final Set<_VariantState> requiredPeerStates;
  final String utility;

  const _ConditionalUtility({
    required this.requiredStates,
    required this.requiredGroupStates,
    required this.requiredPeerStates,
    required this.utility,
  });
}

class _StateScope extends InheritedNotifier<ValueNotifier<Set<_VariantState>>> {
  const _StateScope({
    required super.notifier,
    required super.child,
  });
}

class _GroupStateScope extends _StateScope {
  const _GroupStateScope({required super.notifier, required super.child});

  static ValueNotifier<Set<_VariantState>>? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_GroupStateScope>()
        ?.notifier;
  }
}

class _PeerStateScope extends _StateScope {
  const _PeerStateScope({required super.notifier, required super.child});

  static ValueNotifier<Set<_VariantState>>? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_PeerStateScope>()
        ?.notifier;
  }
}

class _GroupStateHost extends StatefulWidget {
  final Widget child;

  const _GroupStateHost({required this.child});

  @override
  State<_GroupStateHost> createState() => _GroupStateHostState();
}

class _GroupStateHostState extends State<_GroupStateHost> {
  late final ValueNotifier<Set<_VariantState>> _states;
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _states = ValueNotifier<Set<_VariantState>>(<_VariantState>{});
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  void _updateStates() {
    final next = <_VariantState>{};
    if (_isHovered) next.add(_VariantState.hover);
    if (_isFocused) next.add(_VariantState.focus);
    if (_isActive) next.add(_VariantState.active);
    _states.value = next;
  }

  @override
  Widget build(BuildContext context) {
    return _GroupStateScope(
      notifier: _states,
      child: FocusableActionDetector(
        onFocusChange: (value) {
          _isFocused = value;
          _updateStates();
        },
        child: MouseRegion(
          onEnter: (_) {
            _isHovered = true;
            _updateStates();
          },
          onExit: (_) {
            _isHovered = false;
            _updateStates();
          },
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _isActive = true;
              _updateStates();
            },
            onPointerUp: (_) {
              _isActive = false;
              _updateStates();
            },
            onPointerCancel: (_) {
              _isActive = false;
              _updateStates();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _PeerStateHost extends StatefulWidget {
  final Widget child;
  final bool disabled;

  const _PeerStateHost({required this.child, required this.disabled});

  @override
  State<_PeerStateHost> createState() => _PeerStateHostState();
}

class _PeerStateHostState extends State<_PeerStateHost> {
  late final ValueNotifier<Set<_VariantState>> _states;
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _states = ValueNotifier<Set<_VariantState>>(<_VariantState>{});
  }

  @override
  void didUpdateWidget(covariant _PeerStateHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.disabled != widget.disabled) {
      _updateStates();
    }
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  void _updateStates() {
    final next = <_VariantState>{};
    if (_isHovered) next.add(_VariantState.hover);
    if (_isFocused) next.add(_VariantState.focus);
    if (_isActive) next.add(_VariantState.active);
    if (widget.disabled) next.add(_VariantState.disabled);
    _states.value = next;
  }

  @override
  Widget build(BuildContext context) {
    return _PeerStateScope(
      notifier: _states,
      child: FocusableActionDetector(
        onFocusChange: (value) {
          _isFocused = value;
          _updateStates();
        },
        child: MouseRegion(
          onEnter: (_) {
            _isHovered = true;
            _updateStates();
          },
          onExit: (_) {
            _isHovered = false;
            _updateStates();
          },
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _isActive = true;
              _updateStates();
            },
            onPointerUp: (_) {
              _isActive = false;
              _updateStates();
            },
            onPointerCancel: (_) {
              _isActive = false;
              _updateStates();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _InteractiveVariantWrapper extends StatefulWidget {
  final Widget child;
  final List<String> baseUtilities;
  final List<_ConditionalUtility> conditionalUtilities;
  final FlutterWindDiagnosticsCollector? diagnosticsCollector;

  const _InteractiveVariantWrapper({
    required this.child,
    required this.baseUtilities,
    required this.conditionalUtilities,
    this.diagnosticsCollector,
  });

  @override
  State<_InteractiveVariantWrapper> createState() =>
      _InteractiveVariantWrapperState();
}

class _InteractiveVariantWrapperState extends State<_InteractiveVariantWrapper> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isFocusVisible = false;
  bool _isActive = false;
  FocusNode? _trackedFocusNode;

  Set<_VariantState> get _activeStates {
    final states = <_VariantState>{};
    if (_isHovered) states.add(_VariantState.hover);
    if (_isFocused) states.add(_VariantState.focus);
    if (_isFocusVisible) states.add(_VariantState.focusVisible);
    if (_isActive) states.add(_VariantState.active);
    return states;
  }

  List<String> _composeUtilities() {
    final classes = <String>[...widget.baseUtilities];
    final activeStates = _activeStates;
    final groupStates = _GroupStateScope.maybeOf(context)?.value ?? <_VariantState>{};
    final peerStates = _PeerStateScope.maybeOf(context)?.value ?? <_VariantState>{};
    for (final conditional in widget.conditionalUtilities) {
      if (!conditional.requiredGroupStates.every(groupStates.contains)) {
        continue;
      }
      if (!conditional.requiredPeerStates.every(peerStates.contains)) {
        continue;
      }
      if (conditional.requiredStates.every(activeStates.contains)) {
        classes.add(conditional.utility);
      }
    }
    return classes;
  }

  void _onTextFieldFocusChange() {
    final hasFocus = _trackedFocusNode?.hasFocus ?? false;
    if (_isFocused != hasFocus) {
      setState(() {
        _isFocused = hasFocus;
        _isFocusVisible = hasFocus;
      });
    }
  }

  void _trackTextFieldFocus() {
    if (widget.child is! TextField) return;
    final textField = widget.child as TextField;
    final focusNode = textField.focusNode;
    if (focusNode != _trackedFocusNode) {
      _trackedFocusNode?.removeListener(_onTextFieldFocusChange);
      _trackedFocusNode = focusNode;
      _trackedFocusNode?.addListener(_onTextFieldFocusChange);
      _isFocused = _trackedFocusNode?.hasFocus ?? false;
    }
  }

  @override
  void initState() {
    super.initState();
    _trackTextFieldFocus();
  }

  @override
  void didUpdateWidget(covariant _InteractiveVariantWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    _trackTextFieldFocus();
  }

  @override
  void dispose() {
    _trackedFocusNode?.removeListener(_onTextFieldFocusChange);
    _trackedFocusNode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final built = _buildWidgetFromUtilities(
      widget.child,
      _composeUtilities(),
      diagnosticsCollector: widget.diagnosticsCollector,
    );
    
    // For TextField: just pass through with MouseRegion for hover.
    // Ring and focus are handled at the component level (e.g. ShadcnInput)
    // to avoid widget tree changes that cause TextField to lose focus.
    if (widget.child is TextField) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.text,
        child: built,
      );
    }
    
    // For non-TextField widgets, FocusableActionDetector is fine
    return FocusableActionDetector(
      onFocusChange: (value) => setState(() => _isFocused = value),
      onShowFocusHighlight: (value) =>
          setState(() => _isFocusVisible = value),
      mouseCursor: SystemMouseCursors.click,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (_) => setState(() => _isActive = true),
          onTapUp: (_) => setState(() => _isActive = false),
          onTapCancel: () => setState(() => _isActive = false),
          child: built,
        ),
      ),
    );
  }
}

List<String> tokenizeFlutterWindClasses(String classString) {
  final tokens = <String>[];
  final buffer = StringBuffer();
  var bracketDepth = 0;
  var parenDepth = 0;

  for (final rune in classString.runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '[') {
      bracketDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ']') {
      if (bracketDepth > 0) bracketDepth--;
      buffer.write(ch);
      continue;
    }
    if (ch == '(') {
      parenDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ')') {
      if (parenDepth > 0) parenDepth--;
      buffer.write(ch);
      continue;
    }

    final isWhitespace = ch.trim().isEmpty;
    if (isWhitespace && bracketDepth == 0 && parenDepth == 0) {
      final token = buffer.toString().trim();
      if (token.isNotEmpty) tokens.add(token);
      buffer.clear();
      continue;
    }
    buffer.write(ch);
  }

  final trailing = buffer.toString().trim();
  if (trailing.isNotEmpty) {
    tokens.add(trailing);
  }
  return tokens;
}

_ParsedClassToken? _parseClassToken(String token) {
  final clean = token.trim();
  if (clean.isEmpty) return null;

  final segments = <String>[];
  final buffer = StringBuffer();
  var bracketDepth = 0;
  var parenDepth = 0;

  for (final rune in clean.runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '[') {
      bracketDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ']') {
      if (bracketDepth > 0) bracketDepth--;
      buffer.write(ch);
      continue;
    }
    if (ch == '(') {
      parenDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ')') {
      if (parenDepth > 0) parenDepth--;
      buffer.write(ch);
      continue;
    }

    if (ch == ':' && bracketDepth == 0 && parenDepth == 0) {
      segments.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(ch);
  }
  segments.add(buffer.toString());

  if (segments.isEmpty) return null;
  final utility = segments.last.trim();
  if (utility.isEmpty) return null;

  return _ParsedClassToken(
    variants: segments.take(segments.length - 1).map((v) => v.trim()).toList(),
    utility: utility,
  );
}

bool _matchesStaticVariants(List<String> variants, BuildContext? context,
    {bool invalid = false}) {
  if (variants.isEmpty) return true;

  final screens = TailwindConfig.screens;
  for (final variant in variants) {
    if (variant == 'aria-invalid') {
      if (!invalid) return false;
      continue;
    }
    if (variant == 'dark') {
      if (context == null || Theme.of(context).brightness != Brightness.dark) {
        return false;
      }
      continue;
    }
    if (variant == 'light') {
      if (context == null || Theme.of(context).brightness != Brightness.light) {
        return false;
      }
      continue;
    }
    if (variant == 'disabled' || variant == 'input-disabled') {
      continue;
    }
    if (variant == 'group-hover' ||
        variant == 'group-focus' ||
        variant == 'group-active' ||
        variant == 'peer-hover' ||
        variant == 'peer-focus' ||
        variant == 'peer-active' ||
        variant == 'peer-disabled') {
      continue;
    }
    if (screens.containsKey(variant)) {
      if (context == null) return false;
      final width = MediaQuery.of(context).size.width;
      if (width < (screens[variant] ?? double.infinity)) {
        return false;
      }
      continue;
    }
  }
  return true;
}

Set<_VariantState> _extractStateVariants(List<String> variants) {
  final states = <_VariantState>{};
  for (final variant in variants) {
    switch (variant) {
      case 'hover':
      case 'input-hover':
        states.add(_VariantState.hover);
        break;
      case 'focus':
      case 'input-focus':
        states.add(_VariantState.focus);
        break;
      case 'focus-visible':
      case 'input-focus-visible':
        states.add(_VariantState.focusVisible);
        break;
      case 'active':
      case 'input-active':
        states.add(_VariantState.active);
        break;
    }
  }
  return states;
}

Set<_VariantState> _extractGroupStateVariants(List<String> variants) {
  final states = <_VariantState>{};
  for (final variant in variants) {
    switch (variant) {
      case 'group-hover':
        states.add(_VariantState.hover);
        break;
      case 'group-focus':
        states.add(_VariantState.focus);
        break;
      case 'group-active':
        states.add(_VariantState.active);
        break;
    }
  }
  return states;
}

Set<_VariantState> _extractPeerStateVariants(List<String> variants) {
  final states = <_VariantState>{};
  for (final variant in variants) {
    switch (variant) {
      case 'peer-hover':
        states.add(_VariantState.hover);
        break;
      case 'peer-focus':
        states.add(_VariantState.focus);
        break;
      case 'peer-active':
        states.add(_VariantState.active);
        break;
      case 'peer-disabled':
        states.add(_VariantState.disabled);
        break;
    }
  }
  return states;
}

bool isSupportedFlutterWindVariant(String variant) {
  return kFlutterWindSupportedVariants.contains(variant) ||
      TailwindConfig.screens.containsKey(variant);
}

bool isLikelySupportedFlutterWindUtility(String cls) {
  final normalized = cls.trim();
  return kFlutterWindSupportedExactUtilities.contains(normalized) ||
      kFlutterWindSupportedUtilityPrefixes.any(normalized.startsWith);
}

void _warnUnsupportedUtility(String cls) {
  if (!kDebugMode) return;
  if (isLikelySupportedFlutterWindUtility(cls)) return;
  final suggestions = suggestFlutterWindUtilities(cls, maxResults: 2);
  final suffix = suggestions.isEmpty
      ? ''
      : ' Did you mean: ${suggestions.join(', ')}?';
  debugPrint(
      'FlutterWind: unsupported utility "$cls" (ignored in runtime parser).$suffix');
}

void _emitDiagnostic({
  required FlutterWindDiagnosticSeverity severity,
  required String code,
  required String token,
  required String message,
  List<String> suggestions = const <String>[],
  FlutterWindDiagnosticsCollector? collector,
}) {
  final diagnostic = FlutterWindDiagnostic(
    severity: severity,
    code: code,
    token: token,
    message: message,
    suggestions: suggestions,
    timestamp: DateTime.now(),
  );
  collector?.add(diagnostic);
  final merged = <FlutterWindDiagnostic>[...flutterWindDiagnosticsNotifier.value, diagnostic];
  flutterWindDiagnosticsNotifier.value =
      merged.length > 300 ? merged.sublist(merged.length - 300) : merged;
}

Widget _buildWidgetFromUtilities(
  Widget widget,
  List<String> utilityClasses, {
  FlutterWindDiagnosticsCollector? diagnosticsCollector,
}) {
  final style = FlutterWindStyle();

  for (final cls in utilityClasses) {
    applyClassToStyle(cls, style);
    if (!isLikelySupportedFlutterWindUtility(cls)) {
      final suggestions = suggestFlutterWindUtilities(cls, maxResults: 3);
      _emitDiagnostic(
        severity: FlutterWindDiagnosticSeverity.warning,
        code: 'unsupported_utility',
        token: cls,
        message: 'Unsupported utility ignored at runtime.',
        suggestions: suggestions,
        collector: diagnosticsCollector,
      );
    }
    _warnUnsupportedUtility(cls);
  }

  Widget builtWidget;
  if (widget is Text) {
    final textWidget = widget;
    String text = textWidget.data ?? '';

    if (style.textTransform != null) {
      text = _applyTextTransform(text, style.textTransform!);
    }

    final textStyle = _createOptimizedTextStyle(textWidget.style, style);
    builtWidget = style.textSelection != null &&
            style.textSelection != TextSelectionBehavior.none
        ? _createSelectableText(text, textStyle, textWidget, style)
        : _createTextWidget(text, textStyle, textWidget, style);

    if (style.textOverflow == TextOverflow.ellipsis) {
      builtWidget = SizedBox(width: double.infinity, child: builtWidget);
    }
    return style.build(builtWidget);
  }

  if (widget is TextField) {
    final input = _createStyledTextField(widget, style);
    return style.build(input);
  }
  if (widget is TextFormField) {
    final input = _createStyledTextFormField(widget, style);
    return style.build(input);
  }

  return style.build(widget);
}

/// Parses and applies Tailwind-like classes to a widget.
Widget applyFlutterWind(Widget widget, List<String> classes,
    [BuildContext? context,
    FlutterWindDiagnosticsCollector? diagnosticsCollector,
    bool invalid = false]) {
  final baseUtilities = <String>[];
  final conditionalUtilities = <_ConditionalUtility>[];
  var isGroupHost = false;
  var isPeerHost = false;
  var isPeerDisabled = false;

  for (final token in classes) {
    final parsed = _parseClassToken(token);
    if (parsed == null) continue;

    var hasUnsupportedVariant = false;
    for (final variant in parsed.variants) {
      if (!isSupportedFlutterWindVariant(variant)) {
        hasUnsupportedVariant = true;
        final suggestions = suggestFlutterWindVariants(variant, maxResults: 2);
        _emitDiagnostic(
          severity: FlutterWindDiagnosticSeverity.warning,
          code: 'unsupported_variant',
          token: variant,
          message: 'Unsupported variant ignored at runtime.',
          suggestions: suggestions,
          collector: diagnosticsCollector,
        );
        if (kDebugMode) {
          final suffix = suggestions.isEmpty
              ? ''
              : ' Did you mean: ${suggestions.join(', ')}?';
          debugPrint(
              'FlutterWind: unsupported variant "$variant" in "$token" (ignored).$suffix');
        }
      }
    }
    if (hasUnsupportedVariant) {
      continue;
    }

    if (!_matchesStaticVariants(parsed.variants, context, invalid: invalid)) {
      continue;
    }

    final requiresDisabledState = parsed.variants.contains('disabled') ||
        parsed.variants.contains('input-disabled');
    if (requiresDisabledState) {
      if (widget is! TextField && widget is! TextFormField) {
        continue;
      }
      final isEnabled = widget is TextField
          ? (widget.enabled ?? true)
          : (widget as TextFormField).enabled;
      if (isEnabled) {
        continue;
      }
    }

    var resolvedUtility = parsed.utility;
    if ((parsed.variants.contains('disabled') ||
            parsed.variants.contains('input-disabled')) &&
        resolvedUtility == 'opacity') {
      // Support shorthand from examples/docs: input-disabled:opacity
      resolvedUtility = 'opacity-50';
    }
    if (resolvedUtility == 'group') {
      isGroupHost = true;
      continue;
    }
    if (resolvedUtility == 'peer') {
      isPeerHost = true;
      if (widget is TextField) {
        isPeerDisabled = !(widget.enabled ?? true);
      } else if (widget is TextFormField) {
        isPeerDisabled = !widget.enabled;
      }
      continue;
    }

    final stateVariants = _extractStateVariants(parsed.variants);
    final groupStateVariants = _extractGroupStateVariants(parsed.variants);
    final peerStateVariants = _extractPeerStateVariants(parsed.variants);
    if (stateVariants.isEmpty &&
        groupStateVariants.isEmpty &&
        peerStateVariants.isEmpty) {
      baseUtilities.add(resolvedUtility);
    } else {
      conditionalUtilities.add(
        _ConditionalUtility(
          requiredStates: stateVariants,
          requiredGroupStates: groupStateVariants,
          requiredPeerStates: peerStateVariants,
          utility: resolvedUtility,
        ),
      );
    }
  }

  if (conditionalUtilities.isEmpty) {
    Widget built = _buildWidgetFromUtilities(
      widget,
      baseUtilities,
      diagnosticsCollector: diagnosticsCollector,
    );
    if (isGroupHost) {
      built = _GroupStateHost(child: built);
    }
    if (isPeerHost) {
      built = _PeerStateHost(child: built, disabled: isPeerDisabled);
    }
    return built;
  }

  Widget built = _InteractiveVariantWrapper(
    child: widget,
    baseUtilities: baseUtilities,
    conditionalUtilities: conditionalUtilities,
    diagnosticsCollector: diagnosticsCollector,
  );
  if (isGroupHost) {
    built = _GroupStateHost(child: built);
  }
  if (isPeerHost) {
    built = _PeerStateHost(child: built, disabled: isPeerDisabled);
  }
  return built;
}

// Helper function to apply text transformation
String _applyTextTransform(String text, String transform) {
  switch (transform) {
    case 'uppercase':
      return text.toUpperCase();
    case 'lowercase':
      return text.toLowerCase();
    case 'capitalize':
      return text
          .split(' ')
          .map((word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '')
          .join(' ');
    default:
      return text;
  }
}

// Helper function to create optimized TextStyle
TextStyle _createOptimizedTextStyle(
    TextStyle? baseStyle, FlutterWindStyle style) {
  return (baseStyle ?? const TextStyle()).copyWith(
    fontSize: style.textSize,
    color: style.textColor,
    fontWeight: style.fontWeight,
    shadows: style.textShadows,
    letterSpacing: style.letterSpacing,
    wordSpacing: style.wordSpacing,
    height: style.lineHeight,
    decoration: style.textDecoration,
    fontFeatures:
        style.fontVariantNumeric != null ? [style.fontVariantNumeric!] : null,
  );
}

// Helper function to create SelectableText widget
Widget _createSelectableText(String text, TextStyle textStyle,
    Text originalWidget, FlutterWindStyle style) {
  return SelectableText(
    text,
    style: textStyle,
    textAlign: style.textAlign ?? originalWidget.textAlign,
    textDirection: style.textDirection ?? originalWidget.textDirection,
    textScaleFactor: style.textScale ?? originalWidget.textScaleFactor,
    maxLines: style.textOverflow == TextOverflow.ellipsis
        ? 1
        : originalWidget.maxLines,
    selectionControls: MaterialTextSelectionControls(),
    enableInteractiveSelection: true,
  );
}

// Helper function to create Text widget
Widget _createTextWidget(String text, TextStyle textStyle, Text originalWidget,
    FlutterWindStyle style) {
  return Text(
    text,
    style: textStyle,
    textAlign: style.textAlign ?? originalWidget.textAlign,
    textDirection: style.textDirection ?? originalWidget.textDirection,
    locale: originalWidget.locale,
    softWrap: style.textWrap ?? originalWidget.softWrap,
    overflow: style.textOverflow ?? originalWidget.overflow,
    textScaleFactor: style.textScale ?? originalWidget.textScaleFactor,
    maxLines: style.textOverflow == TextOverflow.ellipsis
        ? 1
        : originalWidget.maxLines,
    semanticsLabel: originalWidget.semanticsLabel,
    textWidthBasis: originalWidget.textWidthBasis,
    textHeightBehavior: originalWidget.textHeightBehavior,
  );
}

// Helper function to apply a single class to a style
void applyClassToStyle(String cls, FlutterWindStyle style) {
  final preset = ComponentPresetRegistry.getPreset(cls);
  if (preset != null) {
    final expanded = tokenizeFlutterWindClasses(preset);
    for (final token in expanded) {
      applyClassToStyle(token, style);
    }
    return;
  }

  _ensureDefaultClassHandlersRegistered();
  for (final handler in FlutterWindClassHandlerRegistry.handlers) {
    handler.apply(cls, style);
  }
}

void registerFlutterWindClassHandler(FlutterWindClassHandler handler) {
  FlutterWindClassHandlerRegistry.register(handler);
}

bool _didRegisterDefaultClassHandlers = false;

void _ensureDefaultClassHandlersRegistered() {
  if (_didRegisterDefaultClassHandlers &&
      FlutterWindClassHandlerRegistry.isEmpty == false) {
    return;
  }
  _didRegisterDefaultClassHandlers = true;

  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'spacing',
      order: 10,
      apply: (cls, style) => Spacings.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'colors',
      order: 20,
      apply: (cls, style) => ColorsClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'typography',
      order: 30,
      apply: (cls, style) =>
          TypographyClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'borders',
      order: 40,
      apply: (cls, style) => BordersClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'opacity',
      order: 50,
      apply: (cls, style) => OpacityClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'shadows',
      order: 60,
      apply: (cls, style) => ShadowsClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'sizing',
      order: 70,
      apply: (cls, style) => SizingClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'aspect_ratio',
      order: 80,
      apply: (cls, style) =>
          AspectRatioClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'animations',
      order: 90,
      apply: (cls, style) =>
          AnimationsClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'position',
      order: 100,
      apply: (cls, style) => PositionClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'animation_presets',
      order: 110,
      apply: (cls, style) =>
          AnimationPresets.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'filters',
      order: 120,
      apply: (cls, style) => FilterEffects.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'transforms',
      order: 130,
      apply: (cls, style) => TransformUtils.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'background',
      order: 140,
      apply: (cls, style) => BackgroundClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'text_effects',
      order: 150,
      apply: (cls, style) => TextEffects.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'accessibility',
      order: 160,
      apply: (cls, style) =>
          AccessibilityClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'performance',
      order: 170,
      apply: (cls, style) =>
          PerformanceClass.apply(cls, style as FlutterWindStyle),
    ),
  );
  FlutterWindClassHandlerRegistry.register(
    FlutterWindClassHandler(
      name: 'input',
      order: 180,
      apply: (cls, style) => InputClass.apply(cls, style as FlutterWindStyle),
    ),
  );
}

// Helper function to create styled TextField
Widget _createStyledTextField(TextField textField, FlutterWindStyle style) {
  // Preserve the original decoration's border if it was explicitly set to none
  final originalDecoration = textField.decoration;
  final shouldUseNoBorder = originalDecoration?.border == InputBorder.none &&
      originalDecoration?.enabledBorder == InputBorder.none &&
      originalDecoration?.focusedBorder == InputBorder.none;

  InputDecoration? decoration;
  if (shouldUseNoBorder) {
    // Keep the original decoration with no borders - FlutterWind className handles styling
    decoration = originalDecoration?.copyWith(
      // Ensure background is properly handled
      filled: style.backgroundColor != null && style.backgroundColor != Colors.transparent,
      fillColor: style.backgroundColor,
    );
  } else {
    // Apply style-based borders only if original didn't explicitly disable them
    decoration = originalDecoration?.copyWith(
      border: style.inputBorder ?? originalDecoration.border,
      contentPadding: style.inputPadding ?? originalDecoration.contentPadding,
      enabledBorder: style.inputBorder != null
          ? style.inputBorder?.copyWith(
              borderSide: BorderSide(
                color: style.inputHoverBorderColor ?? Colors.grey,
              ),
            )
          : originalDecoration.enabledBorder,
      focusedBorder: style.inputBorder != null
          ? style.inputBorder?.copyWith(
              borderSide: BorderSide(
                color: style.inputFocusBorderColor ?? Colors.blue,
                width: style.inputFocusWidth ?? 2.0,
              ),
            )
          : originalDecoration.focusedBorder,
      disabledBorder: style.inputBorder != null
          ? style.inputBorder?.copyWith(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            )
          : originalDecoration.disabledBorder,
      filled: style.backgroundColor != null && style.backgroundColor != Colors.transparent,
      fillColor: style.backgroundColor,
    );
  }

  return TextField(
    controller: textField.controller,
    focusNode: textField.focusNode,
    decoration: decoration,
    keyboardType: textField.keyboardType,
    textInputAction: textField.textInputAction,
    textCapitalization: textField.textCapitalization,
    style: textField.style?.copyWith(
      fontSize: style.inputFontSize,
    ),
    strutStyle: textField.strutStyle,
    textAlign: textField.textAlign,
    textAlignVertical: textField.textAlignVertical,
    textDirection: textField.textDirection,
    readOnly: textField.readOnly,
    showCursor: textField.showCursor,
    autofocus: textField.autofocus,
    obscuringCharacter: textField.obscuringCharacter,
    obscureText: textField.obscureText,
    autocorrect: textField.autocorrect,
    smartDashesType: textField.smartDashesType,
    smartQuotesType: textField.smartQuotesType,
    enableSuggestions: textField.enableSuggestions,
    maxLines: textField.maxLines,
    minLines: textField.minLines,
    expands: textField.expands,
    maxLength: textField.maxLength,
    maxLengthEnforcement: textField.maxLengthEnforcement,
    onChanged: textField.onChanged,
    onEditingComplete: textField.onEditingComplete,
    onSubmitted: textField.onSubmitted,
    onAppPrivateCommand: textField.onAppPrivateCommand,
    inputFormatters: textField.inputFormatters,
    enabled: textField.enabled,
    cursorWidth: textField.cursorWidth,
    cursorHeight: textField.cursorHeight,
    cursorRadius: textField.cursorRadius,
    cursorColor: textField.cursorColor,
    selectionHeightStyle: textField.selectionHeightStyle,
    selectionWidthStyle: textField.selectionWidthStyle,
    keyboardAppearance: textField.keyboardAppearance,
    scrollPadding: textField.scrollPadding,
    enableInteractiveSelection: textField.enableInteractiveSelection,
    selectionControls: textField.selectionControls,
    onTap: textField.onTap,
    mouseCursor: textField.mouseCursor,
    buildCounter: textField.buildCounter,
    scrollController: textField.scrollController,
    scrollPhysics: textField.scrollPhysics,
    autofillHints: textField.autofillHints,
    clipBehavior: textField.clipBehavior,
    restorationId: textField.restorationId,
    scribbleEnabled: textField.scribbleEnabled,
    enableIMEPersonalizedLearning: textField.enableIMEPersonalizedLearning,
  );
}

// Helper function to create styled TextFormField
Widget _createStyledTextFormField(
    TextFormField textFormField, FlutterWindStyle style) {
  final decoration = InputDecoration(
    border: style.inputBorder,
    contentPadding: style.inputPadding,
    enabledBorder: style.inputBorder?.copyWith(
      borderSide: BorderSide(
        color: style.inputHoverBorderColor ?? Colors.grey,
      ),
    ),
    focusedBorder: style.inputBorder?.copyWith(
      borderSide: BorderSide(
        color: style.inputFocusBorderColor ?? Colors.blue,
        width: style.inputFocusWidth ?? 2.0,
      ),
    ),
    disabledBorder: style.inputBorder?.copyWith(
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    filled: style.inputHoverBackgroundColor != null,
    fillColor: style.inputHoverBackgroundColor,
  );

  // Create a new TextFormField with the styled decoration
  return TextFormField(
    key: textFormField.key,
    initialValue: textFormField.initialValue,
    decoration: decoration,
    validator: textFormField.validator,
    onSaved: textFormField.onSaved,
    onChanged: textFormField.onChanged,
    enabled: textFormField.enabled,
  );
}
