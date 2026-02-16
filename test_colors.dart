
import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/config/colors.dart';

void main() {
  print('Checking red-300...');
  final red300 = TailwindConfig.resolveColorToken('red-300');
  print('red-300: $red300');

  print('Checking destructive-foreground...');
  // Initialize semantic colors manually since we can't load yaml in bare script easily without mocks,
  // but we can check if defaults are active or if we can simulate it.
  // Actually, destructive-foreground relies on config loading.
  // But red-300 should work out of the box.
  
  if (red300 == null) {
      print('FAIL: red-300 is null');
      print('TailwindConfig.colors contains: ${TailwindConfig.colors.keys.toList()}');
      if (TailwindConfig.colors.isEmpty) {
          print('TailwindConfig.colors is empty. Defaulting...');
          TailwindConfig.colors = defaultTailwindColors;
          final retry = TailwindConfig.resolveColorToken('red-300');
          print('Retry red-300: $retry');
      }
  } else {
      print('PASS: red-300 resolved.');
  }
}
