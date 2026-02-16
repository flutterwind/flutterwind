import 'package:flutter/material.dart';

class RingPainter extends CustomPainter {
  final Color glowColor;
  final double glowRadius;
  final double borderRadius;
  final double borderWidth;
  final double offsetWidth;
  final Color offsetColor;

  RingPainter({
    required this.glowColor,
    required this.glowRadius,
    required this.borderRadius,
    this.borderWidth = 1.0,
    this.offsetWidth = 0.0,
    this.offsetColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw ring offset (solid band between element and ring)
    if (offsetWidth > 0) {
      final offsetRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          -offsetWidth,
          -offsetWidth,
          size.width + (offsetWidth * 2),
          size.height + (offsetWidth * 2),
        ),
        Radius.circular(borderRadius + offsetWidth),
      );
      canvas.drawRRect(
        offsetRRect,
        Paint()
          ..color = offsetColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = offsetWidth,
      );
    }

    // 2. Draw smooth glow ring outside the offset
    final ringStart = offsetWidth;
    final maxGlowRadius = glowRadius * 1.3;
    
    for (double i = maxGlowRadius; i > 0; i -= 0.5) {
      final opacity = (1.0 - (i / maxGlowRadius)) * glowColor.opacity;
      final expand = ringStart + i;
      
      final expandedRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          -expand,
          -expand,
          size.width + (expand * 2),
          size.height + (expand * 2),
        ),
        Radius.circular(borderRadius + expand),
      );
      
      canvas.drawRRect(
        expandedRRect,
        Paint()
          ..color = glowColor.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
    }

    // 3. Draw the main solid ring border at the offset boundary
    final mainRingExpand = ringStart;
    final mainRingRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        -mainRingExpand,
        -mainRingExpand,
        size.width + (mainRingExpand * 2),
        size.height + (mainRingExpand * 2),
      ),
      Radius.circular(borderRadius + mainRingExpand),
    );
    canvas.drawRRect(
      mainRingRRect,
      Paint()
        ..color = glowColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }

  @override
  bool shouldRepaint(RingPainter oldDelegate) {
    return oldDelegate.glowColor != glowColor ||
        oldDelegate.glowRadius != glowRadius ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.offsetWidth != offsetWidth ||
        oldDelegate.offsetColor != offsetColor;
  }
}
