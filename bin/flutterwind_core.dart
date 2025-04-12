import 'dart:io';
import 'package:args/args.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(),
);

// Add a new command for scanning components
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
  sm: "640px"
  md: "768px"
  lg: "1024px"
  xl: "1280px"
  2xl: "1536px"
colors:
  primary: "#3490dc"
  secondary: "#ffed4a"
  danger: "#e3342f"
  success: "#38c172"
  warning: "#ffed4a"
  info: "#6cb2eb"
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
  logger.i('Usage: flutter pub run flutterwind [command]');
  logger.i('Commands:');
  logger.i('  init     Initialize FlutterWind configuration');
  logger.i('  runner   Scan and register page components');
  logger.i('  page     Generate a new page component');
  logger.i('    --name, -n (required)  Name of the page to generate');
  logger.i('    --type, -t             Type of widget (stateless or stateful)');
  logger.i('    --route, -r            Route path for the page');
  logger.i('    --dir, -d              Directory to create the page in');
  logger.i('    --file, -f             Custom file name (e.g., index.dart)');
  logger.i(parser.usage);
}
