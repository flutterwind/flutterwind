import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/classes/grid.dart';
import 'package:flutterwind_core/src/classes/sizing.dart';
import 'package:flutterwind_core/src/classes/spacings.dart';
import 'package:flutterwind_core/src/classes/colors.dart';
import 'package:flutterwind_core/src/classes/typography.dart';
import 'package:flutterwind_core/src/classes/borders.dart';
import 'package:flutterwind_core/src/classes/opacity.dart';
import 'package:flutterwind_core/src/classes/shadows.dart';
import 'package:flutterwind_core/src/inherited/flutterwind_inherited.dart';
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

  // Widget _buildGridWidget(Widget currentChildren) {
  //   if (children == null || children!.isEmpty) {
  //     Log.e("No children provided for grid");
  //     return Container(); // Return empty container if no children
  //   }
  //   print("Grid cols: ${colSpans}");
  //   return GridView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: children?.length ?? 0,
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: gridColumns ?? 2,
  //       mainAxisSpacing: gridGap ?? 0,
  //       crossAxisSpacing: gridGap ?? 0,
  //       childAspectRatio: 1.0,
  //     ),
  //     itemBuilder: (context, index) {
  //       final span = colSpans[index] ?? 1;
  //       return FractionallySizedBox(
  //         widthFactor: span / (gridColumns ?? 2),
  //         child: children![index],
  //       );
  //     },
  //   );
  // }
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
    // GridClass.apply(cls, style);
    // LayoutClass.apply(cls, style);

    // Handle animations
    if (cls.startsWith('transition')) {
      style.transitionDuration = const Duration(milliseconds: 300); // Default
    }
    if (cls.startsWith('duration-')) {
      final match = RegExp(r'duration-(\d+)').firstMatch(cls);
      if (match != null) {
        style.transitionDuration =
            Duration(milliseconds: int.parse(match.group(1)!));
      }
    }
    if (cls == 'ease-in') style.transitionCurve = Curves.easeIn;
    if (cls == 'ease-out') style.transitionCurve = Curves.easeOut;
    if (cls == 'ease-in-out') style.transitionCurve = Curves.easeInOut;
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
  return builtWidget;
}
