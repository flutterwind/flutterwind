import 'package:flutter/material.dart';

extension GestureExtension on Widget {
  Widget withGestures({VoidCallback? onTap, VoidCallback? onDoubleTap}) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: this,
    );
  }
}
