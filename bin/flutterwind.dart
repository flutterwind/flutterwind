import 'dart:io';
import 'package:args/args.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(),
);

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('init')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Displays this help information.');

  final argResults = parser.parse(arguments);

  if (argResults['help'] as bool) {
    _printUsage(parser);
    return;
  }

  if (argResults.command?.name == 'init') {
    _initializeConfig();
  } else {
    logger.i('Invalid command.');
    _printUsage(parser);
  }
}

void _initializeConfig() {
  const configContent = '''
screens:
  sm: 640px
  md: 768px
  lg: 1024px
  xl: 1280px
  '2xl': 1536px
colors:
  red-500: "#ef4444"
  blue-500: "#3b82f6"
  green-500: "#10b981"
spacing:
  1: 4.0
  2: 8.0
  3: 12.0
  4: 16.0
  5: 20.0
  6: 24.0
fontFamily:
  sans: ['ui-sans-serif', 'system-ui']
  serif: ['ui-serif', 'Georgia']
  mono: ['ui-monospace', 'SFMono-Regular']
fontSize:
  sm: 12.0
  base: 16.0
  lg: 18.0
  xl: 24.0
borderRadius:
  none: 0.0
  sm: 2.0
  md: 4.0
  lg: 8.0
  full: 9999.0
boxShadow:
  sm: '0 1px 2px rgba(0, 0, 0, 0.05)'
  md: '0 4px 6px rgba(0, 0, 0, 0.1)'
  lg: '0 10px 15px rgba(0, 0, 0, 0.15)'
''';

  try {
    final file = File('tailwind.config.yaml');
    if (file.existsSync()) {
      logger.w('tailwind.config.yaml already exists.');
    } else {
      file.writeAsStringSync(configContent);
      logger.i('tailwind.config.yaml has been created.');
    }
  } catch (e, stackTrace) {
    logger.e('Error initializing tailwind.config.yaml',
        error: e, stackTrace: stackTrace);
  }
}

void _printUsage(ArgParser parser) {
  logger.i('Usage: flutter pub run flutterwind init');
  logger.i(parser.usage);
}
