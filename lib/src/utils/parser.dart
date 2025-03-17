import 'package:flutter/material.dart';
import 'package:flutterwind/src/classes/sizing.dart';
import 'package:flutterwind/src/classes/spacings.dart';
import 'package:flutterwind/src/classes/colors.dart';
import 'package:flutterwind/src/classes/typography.dart';
import 'package:flutterwind/src/classes/borders.dart';
import 'package:flutterwind/src/classes/opacity.dart';
import 'package:flutterwind/src/classes/shadows.dart';

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

  // New sizing properties:
  double? width; // Fixed width in pixels
  double? height; // Fixed height in pixels
  double? widthFactor; // Relative width (e.g. 0.5 for 50%)
  double? heightFactor; // Relative height

  // NEW: Inset shadows (not directly supported by Flutter’s BoxShadow)
  List<BoxShadow>? insetBoxShadows;

  // NEW: Ring properties – for focus outlines etc.
  BoxShadow? ringShadow;
  Color? ringColor;
  double? ringWidth;

  MainAxisAlignment? mainAxisAlignment;
  CrossAxisAlignment? crossAxisAlignment;
  bool isFlex = false;
  bool isColumn = false;
  List<Widget>? children;

  // New gesture properties:
  VoidCallback? onTap;
  VoidCallback? onDoubleTap;
  VoidCallback? onLongPress;

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

    // Handle opacity wrapper
    if (opacity != null) {
      current = Opacity(opacity: opacity!, child: current);
    }

    // Apply Container styles
    if (padding != null ||
        backgroundColor != null ||
        borderRadius != null ||
        boxShadows != null) {
      current = Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: boxShadows,
        ),
        child: current,
      );
    }

    // Apply margin
    if (margin != null) {
      current = Padding(padding: margin!, child: current);
    }

    if (insetBoxShadows != null) {
      // Here we simply store them; you might later use them in a custom widget.
      // For now, we leave them as a property on the style.
    }

    // Apply ring effect by layering a Container with a border if ringShadow is set.
    if (ringShadow != null || ringColor != null || ringWidth != null) {
      current = Container(
        decoration: BoxDecoration(
          // Use border to simulate ring effect.
          border: Border.all(
            color: ringColor ?? Colors.black,
            width: ringWidth ?? 1,
          ),
        ),
        child: current,
      );
    }

    // Handle Flexbox (Row/Column) if needed
    if (isFlex && children != null) {
      current = isColumn
          ? Column(
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.start,
              children: children!,
            )
          : Row(
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: children!,
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
Widget applyFlutterWind(Widget widget, List<String> classes) {
  final style = FlutterWindStyle();
  bool isTextWidget = widget is Text;

  for (final cls in classes) {
    Spacings.apply(cls, style);
    ColorsClass.apply(cls, style);
    TypographyClass.apply(cls, style);
    BordersClass.apply(cls, style);
    OpacityClass.apply(cls, style);
    ShadowsClass.apply(cls, style);
    SizingClass.apply(cls, style);
    // LayoutClass.apply(cls, style);
  }

  // If it's a Text widget, apply text styles and then wrap it in container styles.
  if (isTextWidget) {
    final textWidget = widget as Text;
    final styledText = Text(
      textWidget.data ?? "",
      style: TextStyle(
        fontSize: style.textSize,
        fontWeight: style.fontWeight,
        color: style.textColor,
      ),
      textAlign: textWidget.textAlign,
      textDirection: textWidget.textDirection,
      locale: textWidget.locale,
      softWrap: textWidget.softWrap,
      overflow: textWidget.overflow,
      textScaleFactor: textWidget.textScaleFactor,
      maxLines: textWidget.maxLines,
      semanticsLabel: textWidget.semanticsLabel,
    );
    return style.build(styledText);
  }

  return style.build(widget);
}
