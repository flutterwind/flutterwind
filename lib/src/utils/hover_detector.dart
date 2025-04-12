import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class HoverDetector extends StatefulWidget {
  final Widget child;
  final List<String> baseClasses;
  final List<String> hoverClasses;
  final BuildContext context;

  const HoverDetector({
    super.key,
    required this.child,
    required this.baseClasses,
    required this.hoverClasses,
    required this.context,
  });

  @override
  State<HoverDetector> createState() => _HoverDetectorState();
}

class _HoverDetectorState extends State<HoverDetector> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Use MouseRegion for both web and desktop platforms
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Builder(builder: (context) {
        if (!isHovered) {
          return applyFlutterWind(
            widget.child,
            widget.baseClasses,
            widget.context,
          );
        }

        // Apply hover styles when hovered
        final allClasses = [
          ...widget.baseClasses,
          ...widget.hoverClasses,
        ];

        // Use the existing applyFlutterWind function
        return applyFlutterWind(
          widget.child is Text ? (widget.child as Text) : widget.child,
          allClasses,
          widget.context,
        );
      }),
    );
  }
}
