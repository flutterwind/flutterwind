import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/classes/animation_presets.dart';
import 'package:flutterwind_core/src/classes/animations.dart';
import 'package:flutterwind_core/src/classes/aspect_ratio.dart';
import 'package:flutterwind_core/src/classes/position.dart';
import 'package:flutterwind_core/src/classes/sizing.dart';
import 'package:flutterwind_core/src/classes/spacings.dart';
import 'package:flutterwind_core/src/classes/colors.dart';
import 'package:flutterwind_core/src/classes/typography.dart';
import 'package:flutterwind_core/src/classes/borders.dart';
import 'package:flutterwind_core/src/classes/opacity.dart';
import 'package:flutterwind_core/src/classes/shadows.dart';
import 'package:flutterwind_core/src/inherited/flutterwind_inherited.dart';
import 'package:flutterwind_core/src/utils/flutterwind_breakpoints.dart';
import 'package:flutterwind_core/src/utils/hover_detector.dart';
import 'package:flutterwind_core/src/utils/logger.dart';

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

  // New sizing properties:
  double? width; // Fixed width in pixels
  double? height; // Fixed height in pixels
  double? widthFactor; // Relative width (e.g. 0.5 for 50%)
  double? heightFactor; // Relative height

  // NEW: Inset shadows (not directly supported by Flutter’s BoxShadow)
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
  Curve? transitionCurve;

  // Add aspect ratio property
  double? aspectRatio;

  // Position properties
  PositionType? position;
  double? insetTop;
  double? insetRight;
  double? insetBottom;
  double? insetLeft;

  // Animation preset
  AnimationPreset? animationPreset;

  Widget build(Widget child) {
    Widget current = child;

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

    return current;
  }
}

/// Parses and applies Tailwind-like classes to a widget.
Widget applyFlutterWind(Widget widget, List<String> classes,
    [BuildContext? context]) {
  final style = FlutterWindStyle();
  bool isTextWidget = widget is Text;

  // First, separate hover classes from regular classes
  final baseClasses = <String>[];
  final hoverClasses = <String>[];
  final darkClasses = <String>[];

  for (final cls in classes) {
    if (cls.startsWith('hover:')) {
      hoverClasses.add(cls.substring(6)); // Remove 'hover:' prefix
    } else if (cls.startsWith('dark:')) {
      darkClasses.add(cls.substring(5)); // Remove 'dark:' prefix
    } else {
      baseClasses.add(cls);
    }
  }

  // Resolve responsive classes based on current screen size
  final resolvedBaseClasses = context != null
      ? resolveFlutterWindResponsiveClasses(baseClasses, context)
      : baseClasses;

  // Also resolve responsive classes for hover states
  final resolvedHoverClasses = context != null && hoverClasses.isNotEmpty
      ? resolveFlutterWindResponsiveClasses(hoverClasses, context)
      : hoverClasses;

  final resolvedDarkClasses = context != null && darkClasses.isNotEmpty
      ? resolveFlutterWindResponsiveClasses(darkClasses, context)
      : darkClasses;

  // Determine if dark mode is active
  final isDarkMode =
      context != null && Theme.of(context).brightness == Brightness.dark;

  // Apply base styles
  for (final cls in resolvedBaseClasses) {
    applyClassToStyle(cls, style);
  }

  // Apply dark mode styles if in dark mode
  if (isDarkMode && resolvedDarkClasses.isNotEmpty) {
    for (final cls in resolvedDarkClasses) {
      applyClassToStyle(cls, style);
    }
  }

  Widget builtWidget;

  // If it's a Text widget, apply text styles and then wrap it in container styles.
  if (isTextWidget) {
    final textWidget = widget;
    builtWidget = Text(
      textWidget.data ?? "",
      style: TextStyle(
        fontSize: style.textSize,
        fontWeight: style.fontWeight,
        color: style.textColor,
      ),
      textAlign: style.textAlign,
      textDirection: textWidget.textDirection,
      locale: textWidget.locale,
      softWrap: textWidget.softWrap,
      overflow: textWidget.overflow,
      textScaleFactor: textWidget.textScaleFactor,
      maxLines: textWidget.maxLines,
      semanticsLabel: textWidget.semanticsLabel,
    );
  } else {
    builtWidget = style.build(widget);
  }

  // If there are hover classes, wrap with hover detector
  if (resolvedHoverClasses.isNotEmpty && context != null) {
    // For hover, we need to pass both base classes and dark classes
    final baseClassesWithDark = isDarkMode && resolvedDarkClasses.isNotEmpty
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
}
