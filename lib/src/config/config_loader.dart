import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/utils/logger.dart';

class ConfigLoader {
  static Future<void> loadConfig() async {
    try {
      final file = File('tailwind.config.yaml');
      if (await file.exists()) {
        final content = await file.readAsString();
        final yamlMap = loadYaml(content);
        TailwindConfig.updateFromYaml(yamlMap);
      } else {
        Log.e('Configuration file not found.');
      }
    } catch (e, stackTrace) {
      // Implement your logging mechanism here.
      Log.e('Error reading configuration file', e, stackTrace);
    }
  }
}
