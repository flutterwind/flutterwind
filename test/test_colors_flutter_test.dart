
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/config/colors.dart';

void main() {
  test('Check red-300 resolution', () {
    print('Checking red-300...');
    // Ensure default colors are loaded if not already
    if (TailwindConfig.colors.isEmpty) {
        TailwindConfig.colors = defaultTailwindColors;
    }

    final red300 = TailwindConfig.resolveColorToken('red-300');
    print('red-300: $red300');
    
    expect(red300, isNotNull);
    expect(red300, equals(Color(0xFFFFA2A2)));
  });
}
