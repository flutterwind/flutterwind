import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import 'package:flutterwind_core/src/config/tailwind_config.dart';
import 'package:flutterwind_core/src/utils/logger.dart';

class ConfigLoader {
  static Future<void> loadConfig() async {
    try {
      final yamlString = await rootBundle.loadString('tailwind.config.yaml');
      print("yamlString ::: $yamlString");
      if (yamlString.isNotEmpty) {
        final yamlMap = loadYaml(yamlString);
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
