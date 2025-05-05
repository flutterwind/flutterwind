import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutterwind_core/src/classes/animation_presets.dart';
import 'package:flutterwind_core/src/classes/animations.dart';
import 'package:flutterwind_core/src/classes/aspect_ratio.dart';
import 'package:flutterwind_core/src/classes/filter_effects.dart';
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

  // New sizing properties:
  double? width; // Fixed width in pixels
  double? height; // Fixed height in pixels
  double? widthFactor; // Relative width (e.g. 0.5 for 50%)
  double? heightFactor; // Relative height

  // NEW: Overflow handling
  bool? overFlowScroll;
  bool? overFlowHidden;
  Axis? overFlowScrollAxis;

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

    // Apply image filter (blur) if specified
    if (imageFilter != null) {
      current = ImageFiltered(
        imageFilter: imageFilter!,
        child: current,
      );
    }
    
    // Apply typography features
    if (textDecoration != null || textTransform != null || fontVariantNumeric != null || textIndent != null) {
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
                transformedText = transformedText.split(' ')
                  .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
                  .join(' ');
              }
              
              // Create a new Text widget with the transformed text
              current = Text(
                transformedText,
                style: textWidget.style?.copyWith(
                  decoration: textDecoration,
                  fontFeatures: fontVariantNumeric != null ? [fontVariantNumeric!] : null,
                ) ?? textStyle,
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
                fontFeatures: fontVariantNumeric != null ? [fontVariantNumeric!] : null,
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
  FilterEffects.apply(cls, style);
  TransformUtils.apply(cls, style);
}
