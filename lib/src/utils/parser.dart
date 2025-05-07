import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutterwind_core/src/classes/animation_presets.dart';
import 'package:flutterwind_core/src/classes/animations.dart';
import 'package:flutterwind_core/src/classes/aspect_ratio.dart';
import 'package:flutterwind_core/src/classes/filter_effects.dart';
import 'package:flutterwind_core/src/classes/input.dart';
import 'package:flutterwind_core/src/classes/text_effects.dart';
import 'package:flutterwind_core/src/classes/transform_utils.dart';
import 'package:flutterwind_core/src/classes/position.dart';
import 'package:flutterwind_core/src/classes/sizing.dart';
import 'package:flutterwind_core/src/classes/spacings.dart';
import 'package:flutterwind_core/src/classes/colors.dart';
import 'package:flutterwind_core/src/classes/typography.dart';
import 'package:flutterwind_core/src/classes/borders.dart';
import 'package:flutterwind_core/src/classes/opacity.dart';
import 'package:flutterwind_core/src/classes/shadows.dart';
import 'package:flutterwind_core/src/utils/flutterwind_breakpoints.dart';
import 'package:flutterwind_core/src/utils/hover_detector.dart';
import 'package:flutterwind_core/src/classes/background.dart';
import 'package:flutterwind_core/src/classes/accessibility.dart';
import 'package:flutterwind_core/src/classes/performance.dart';
import 'package:flutterwind_core/src/widgets/performance_widgets.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

class FlutterWindStyle {
  EdgeInsets? padding;
  EdgeInsets? margin;
  Color? backgroundColor;
  double? textSize;
  Color? textColor;
  FontWeight? fontWeight;
  BorderRadius? borderRadius;
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
          image: DecorationImage(
            image: AssetImage(''), // Placeholder image
            fit: backgroundFit ?? BoxFit.none,
            alignment: backgroundAlignment ?? Alignment.center,
            colorFilter:
                backgroundBlendMode != null || backgroundOpacity != null
                    ? ColorFilter.mode(
                        Colors.white.withOpacity(backgroundOpacity ?? 1.0),
                        backgroundBlendMode ?? BlendMode.srcOver,
                      )
                    : null,
            repeat: backgroundRepeat ?? ImageRepeat.noRepeat,
          ),
        ),
        child: current,
      );
    }

    // Apply image filter (blur) if specified
    if (imageFilter != null) {
      current = ImageFiltered(
        imageFilter: imageFilter!,
        child: current,
      );
    }

    // Apply typography features
    if (textDecoration != null ||
        textTransform != null ||
        fontVariantNumeric != null ||
        textIndent != null) {
      TextStyle textStyle = TextStyle(
        decoration: textDecoration,
        fontFeatures: fontVariantNumeric != null ? [fontVariantNumeric!] : null,
      );

      // Apply text transformation
      if (textTransform != null) {
        current = Builder(
          builder: (context) {
            String transformedText = '';
            // Get the text from the child widget if possible
            if (current is Text) {
              final textWidget = current as Text;
              transformedText = textWidget.data ?? '';

              // Apply the transformation
              if (textTransform == 'uppercase') {
                transformedText = transformedText.toUpperCase();
              } else if (textTransform == 'lowercase') {
                transformedText = transformedText.toLowerCase();
              } else if (textTransform == 'capitalize') {
                transformedText = transformedText
                    .split(' ')
                    .map((word) => word.isNotEmpty
                        ? '${word[0].toUpperCase()}${word.substring(1)}'
                        : '')
                    .join(' ');
              }

              // Create a new Text widget with the transformed text
              current = Text(
                transformedText,
                style: textWidget.style?.copyWith(
                      decoration: textDecoration,
                      fontFeatures: fontVariantNumeric != null
                          ? [fontVariantNumeric!]
                          : null,
                    ) ??
                    textStyle,
                textAlign: textWidget.textAlign ?? textAlign,
                maxLines: textWidget.maxLines,
                overflow: textWidget.overflow,
                softWrap: textWidget.softWrap,
              );
            }
            return current;
          },
        );
      } else if (textDecoration != null || fontVariantNumeric != null) {
        // Apply text style without transformation
        current = Builder(
          builder: (context) {
            return DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(
                    decoration: textDecoration,
                    fontFeatures: fontVariantNumeric != null
                        ? [fontVariantNumeric!]
                        : null,
                  ),
              child: current,
            );
          },
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

    // Apply aspect ratio if specified
    if (aspectRatio != null) {
      current = AspectRatio(
        aspectRatio: aspectRatio!,
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
                boxShadow: boxShadows,
              ),
              child: current,
            );
    }

    if (insetBoxShadows != null) {
      // Here we simply store them; you might later use them in a custom widget.
      // For now, we leave them as a property on the style.
    }

    // Handle ring effect using box shadows
    if (ringShadow != null || ringColor != null || ringWidth != null) {
      current = Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (ringShadow != null) ringShadow!,
            BoxShadow(
              color: ringColor ?? Colors.transparent,
              spreadRadius: (ringWidth ?? 0) * 0.5,
              blurRadius: 0,
            ),
          ],
        ),
        child: current,
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

    print("current :: $current");

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

    return current;
  }
}

/// Parses and applies Tailwind-like classes to a widget.
Widget applyFlutterWind(Widget widget, List<String> classes,
    [BuildContext? context]) {
  final style = FlutterWindStyle();
  final isTextWidget = widget is Text;
  final isInputWidget = widget is TextField || widget is TextFormField;

  // Pre-allocate lists with estimated capacity
  final baseClasses = <String>[];
  final hoverClasses = <String>[];
  final darkClasses = <String>[];

  // Single pass classification of classes
  for (final cls in classes) {
    if (cls.startsWith('hover:')) {
      hoverClasses.add(cls.substring(6));
    } else if (cls.startsWith('dark:')) {
      darkClasses.add(cls.substring(5));
    } else {
      baseClasses.add(cls);
    }
  }

  // Resolve responsive classes only if context is available
  final resolvedBaseClasses = context != null
      ? resolveFlutterWindResponsiveClasses(baseClasses, context)
      : baseClasses;

  final resolvedHoverClasses = context != null && hoverClasses.isNotEmpty
      ? resolveFlutterWindResponsiveClasses(hoverClasses, context)
      : hoverClasses;

  final resolvedDarkClasses = context != null && darkClasses.isNotEmpty
      ? resolveFlutterWindResponsiveClasses(darkClasses, context)
      : darkClasses;

  // Apply base styles
  for (final cls in resolvedBaseClasses) {
    applyClassToStyle(cls, style);
  }

  // Apply dark mode styles if active
  if (context != null &&
      Theme.of(context).brightness == Brightness.dark &&
      resolvedDarkClasses.isNotEmpty) {
    for (final cls in resolvedDarkClasses) {
      applyClassToStyle(cls, style);
    }
  }

  Widget builtWidget;

  // Handle Text widget with optimized style application
  if (isTextWidget) {
    final textWidget = widget as Text;
    String text = textWidget.data ?? '';

    // Apply text transformation if needed
    if (style.textTransform != null) {
      text = _applyTextTransform(text, style.textTransform!);
    }

    // Create optimized TextStyle
    final textStyle = _createOptimizedTextStyle(textWidget.style, style);

    // Create appropriate text widget based on selection behavior
    builtWidget = style.textSelection != null &&
            style.textSelection != TextSelectionBehavior.none
        ? _createSelectableText(text, textStyle, textWidget, style)
        : _createTextWidget(text, textStyle, textWidget, style);

    // Handle ellipsis overflow
    if (style.textOverflow == TextOverflow.ellipsis) {
      builtWidget = SizedBox(width: double.infinity, child: builtWidget);
    }
  }
  // Handle Input widget with optimized style application
  else if (isInputWidget) {
    if (widget is TextField) {
      builtWidget = _createStyledTextField(widget as TextField, style);
    } else {
      builtWidget = _createStyledTextFormField(widget as TextFormField, style);
    }
  } else {
    builtWidget = style.build(widget);
  }

  // Apply hover effects if needed
  if (resolvedHoverClasses.isNotEmpty && context != null) {
    final baseClassesWithDark =
        Theme.of(context).brightness == Brightness.dark &&
                resolvedDarkClasses.isNotEmpty
            ? [...baseClasses, ...darkClasses]
            : baseClasses;

    return HoverDetector(
      baseClasses: baseClassesWithDark,
      hoverClasses: hoverClasses,
      context: context,
      child: widget,
    );
  }

  return builtWidget;
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
  Spacings.apply(cls, style);
  ColorsClass.apply(cls, style);
  TypographyClass.apply(cls, style);
  BordersClass.apply(cls, style);
  OpacityClass.apply(cls, style);
  ShadowsClass.apply(cls, style);
  SizingClass.apply(cls, style);
  AspectRatioClass.apply(cls, style);
  AnimationsClass.apply(cls, style);
  PositionClass.apply(cls, style);
  AnimationPresets.apply(cls, style);
  FilterEffects.apply(cls, style);
  TransformUtils.apply(cls, style);
  BackgroundClass.apply(cls, style);
  TextEffects.apply(cls, style);
  AccessibilityClass.apply(cls, style);
  PerformanceClass.apply(cls, style);
  InputClass.apply(cls, style);
}

// Helper function to create styled TextField
Widget _createStyledTextField(TextField textField, FlutterWindStyle style) {
  final decoration = textField.decoration?.copyWith(
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
  // Create a new InputDecoration with the styled properties
  print("border :: ${style.inputBorder}");
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
