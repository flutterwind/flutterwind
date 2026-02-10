import 'dart:io';
import 'package:args/args.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(),
);

const List<String> kFlutterWindSupportedVariants = <String>[
  'dark',
  'light',
  'hover',
  'focus',
  'focus-visible',
  'active',
  'input-hover',
  'input-focus',
  'input-focus-visible',
  'input-active',
  'group-hover',
  'group-focus',
  'group-active',
  'peer-hover',
  'peer-focus',
  'peer-active',
  'peer-disabled',
  'disabled',
  'input-disabled',
];

const List<String> kFlutterWindSupportedUtilityPrefixes = <String>[
  'font-',
  'p-',
  'pt-',
  'pb-',
  'pl-',
  'pr-',
  'px-',
  'py-',
  'ps-',
  'pe-',
  'm-',
  'mt-',
  'mb-',
  'ml-',
  'mr-',
  'mx-',
  'my-',
  'ms-',
  'me-',
  'flex',
  'flex-',
  'grid',
  'grid-',
  'gap-',
  'space-x-',
  'space-y-',
  'justify-',
  'items-',
  'content-',
  'grow-',
  'shrink-',
  'basis-',
  'auto-flow-',
  'col-span-',
  'bg-',
  'text-',
  'input-',
  'tracking-',
  'word-spacing-',
  'leading-',
  'from-',
  'via-',
  'to-',
  'rounded',
  'opacity-',
  'shadow',
  'w-',
  'h-',
  'size-',
  'overflow-',
  'aspect-',
  'animate-',
  'transition-',
  'duration-',
  'delay-',
  'ease-',
  'top-',
  'right-',
  'bottom-',
  'left-',
  'inset-',
  'scale-',
  'rotate-',
  'translate-',
  'skew-',
  'origin-',
  'blur-',
  'backdrop-blur-',
  'backdrop-filter',
  'blend-',
  'shader-',
  'brightness-',
  'contrast-',
  'drop-shadow',
  'sr-only',
  'focusable',
  'focus-order-',
  'lazy-load',
  'cache',
  'memory-optimize',
  'optimize-memory',
  'no-optimize-memory',
  'image-optimize-',
  'widget-recycle',
  'debounce-',
  'throttle-',
  'btn-',
  'card-',
  'border',
];

const Set<String> kFlutterWindSupportedExactUtilities = <String>{
  'underline',
  'line-through',
  'overline',
  'no-underline',
  'uppercase',
  'lowercase',
  'capitalize',
  'normal-case',
  'select-none',
  'select-text',
  'select-all',
  'rtl',
  'ltr',
  'focus-first',
  'focus-last',
  'text-wrap',
  'aria-live',
  'outline',
  'outline-none',
  'group',
  'peer',
  'btn',
  'card',
  'card-header',
  'card-body',
  'input-filled',
};

const Map<String, double> kDefaultBreakpoints = <String, double>{
  'sm': 640,
  'md': 768,
  'lg': 1024,
  'xl': 1280,
  '2xl': 1536,
};

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('validate')
    ..addCommand('matrix')
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Displays this help information.');

  parser.commands['validate']!
    ..addOption(
      'path',
      abbr: 'p',
      defaultsTo: '.',
      help: 'Directory to scan for .className(...) calls',
    )
    ..addMultiOption(
      'include',
      abbr: 'i',
      help: 'Optional path fragments to include (repeatable)',
    )
    ..addMultiOption(
      'exclude',
      abbr: 'e',
      help: 'Path fragments to exclude (repeatable)',
    )
    ..addFlag(
      'fail-on-error',
      negatable: false,
      help: 'Exit with non-zero code when issues are found',
    );

  parser.commands['matrix']!
    ..addOption(
      'out',
      abbr: 'o',
      defaultsTo: 'doc/generated_support_matrix.md',
      help: 'Output markdown path',
    );

  final argResults = parser.parse(arguments);

  if (argResults['help'] as bool) {
    _printUsage(parser);
    return;
  }

  if (argResults.command?.name == 'init') {
    _initializeConfig();
  } else if (argResults.command?.name == 'validate') {
    _validateClasses(argResults.command!);
  } else if (argResults.command?.name == 'matrix') {
    _generateSupportMatrix(argResults.command!);
  } else {
    logger.i('Invalid command.');
    _printUsage(parser);
  }
}

void _validateClasses(ArgResults command) {
  final targetPath = command['path'] as String? ?? '.';
  final includeFilters =
      (command['include'] as List<String>? ?? const <String>[])
          .where((e) => e.trim().isNotEmpty)
          .toList();
  final excludeFilters =
      (command['exclude'] as List<String>? ?? const <String>[])
          .where((e) => e.trim().isNotEmpty)
          .toList();
  final failOnError = command['fail-on-error'] as bool? ?? false;

  final root = Directory(targetPath);
  if (!root.existsSync()) {
    logger.e('Path does not exist: $targetPath');
    if (failOnError) {
      exitCode = 2;
    }
    return;
  }

  final dartFiles = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) {
        final normalized = f.path.replaceAll('\\', '/');
        if (includeFilters.isNotEmpty &&
            !includeFilters.any(normalized.contains)) {
          return false;
        }
        if (excludeFilters.any(normalized.contains)) {
          return false;
        }
        return true;
      })
      .toList();

  final issues = <String>[];
  var scannedStrings = 0;

  for (final file in dartFiles) {
    final source = file.readAsStringSync();
    final matches = RegExp(
      'className\\(\\s*([\\\'"])(.*?)\\1\\s*\\)',
      dotAll: true,
    ).allMatches(source);

    for (final match in matches) {
      scannedStrings++;
      final classString = match.group(2) ?? '';
      final tokens = _tokenizeFlutterWindClasses(classString);
      for (final token in tokens) {
        final split = _splitVariantChain(token);
        for (final variant in split.variants) {
          if (!_isSupportedFlutterWindVariant(variant)) {
            final suggestions =
                _suggestFlutterWindVariants(variant, maxResults: 3);
            issues.add(
              '${file.path}: unsupported variant "$variant" in "$token"'
              '${suggestions.isNotEmpty ? ' (did you mean: ${suggestions.join(', ')})' : ''}',
            );
          }
        }
        if (!_isLikelySupportedFlutterWindUtility(split.utility)) {
          final suggestions =
              _suggestFlutterWindUtilities(split.utility, maxResults: 3);
          issues.add(
            '${file.path}: unsupported utility "${split.utility}" in "$token"'
            '${suggestions.isNotEmpty ? ' (did you mean: ${suggestions.join(', ')})' : ''}',
          );
        }
      }
    }
  }

  logger.i('Scanned $scannedStrings className() strings in ${dartFiles.length} Dart files.');
  if (issues.isEmpty) {
    logger.i('No unsupported utilities/variants found.');
    return;
  }

  logger.w('Found ${issues.length} potential issues:');
  for (final issue in issues) {
    logger.w(issue);
  }
  if (failOnError) {
    exitCode = 1;
  }
}

void _generateSupportMatrix(ArgResults command) {
  final outPath = command['out'] as String? ?? 'doc/generated_support_matrix.md';
  final outFile = File(outPath);
  outFile.parent.createSync(recursive: true);

  final buffer = StringBuffer()
    ..writeln('# Generated FlutterWind Support Matrix')
    ..writeln()
    ..writeln('This file is generated from runtime parser support lists.')
    ..writeln()
    ..writeln('- Generated at (UTC): `${DateTime.now().toUtc().toIso8601String()}`')
    ..writeln('- Command: `flutter pub run bin/flutterwind_core.dart matrix`')
    ..writeln()
    ..writeln('## Supported Variants')
    ..writeln()
    ..writeln('| Variant |')
    ..writeln('| --- |');
  for (final v in kFlutterWindSupportedVariants) {
    buffer.writeln('| `$v` |');
  }
  buffer
    ..writeln()
    ..writeln('## Supported Utility Prefixes')
    ..writeln()
    ..writeln('| Prefix |')
    ..writeln('| --- |');
  for (final p in kFlutterWindSupportedUtilityPrefixes) {
    buffer.writeln('| `$p` |');
  }
  buffer
    ..writeln()
    ..writeln('## Supported Exact Utilities')
    ..writeln()
    ..writeln('| Utility |')
    ..writeln('| --- |');
  for (final u in kFlutterWindSupportedExactUtilities.toList()..sort()) {
    buffer.writeln('| `$u` |');
  }
  buffer
    ..writeln()
    ..writeln('## Responsive Breakpoints (Current Config)')
    ..writeln()
    ..writeln('| Breakpoint | Min Width (px) |')
    ..writeln('| --- | ---: |');
  final breakpoints = kDefaultBreakpoints.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));
  for (final entry in breakpoints) {
    buffer.writeln('| `${entry.key}` | ${entry.value.toStringAsFixed(0)} |');
  }

  outFile.writeAsStringSync(buffer.toString());
  logger.i('Generated support matrix at ${outFile.path}');
}

_VariantSplit _splitVariantChain(String token) {
  final parts = <String>[];
  final buffer = StringBuffer();
  var bracketDepth = 0;
  var parenDepth = 0;

  for (final rune in token.runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '[') {
      bracketDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ']') {
      if (bracketDepth > 0) bracketDepth--;
      buffer.write(ch);
      continue;
    }
    if (ch == '(') {
      parenDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ')') {
      if (parenDepth > 0) parenDepth--;
      buffer.write(ch);
      continue;
    }
    if (ch == ':' && bracketDepth == 0 && parenDepth == 0) {
      parts.add(buffer.toString());
      buffer.clear();
      continue;
    }
    buffer.write(ch);
  }
  parts.add(buffer.toString());

  if (parts.length <= 1) {
    return _VariantSplit(const <String>[], token);
  }
  return _VariantSplit(parts.sublist(0, parts.length - 1), parts.last);
}

class _VariantSplit {
  final List<String> variants;
  final String utility;

  _VariantSplit(this.variants, this.utility);
}

void _initializeConfig() {
  const configContent = '''
theme:
  tokens:
    light:
      surface: "#ffffff"
      surface-foreground: "#111827"
      muted: "#f3f4f6"
      muted-foreground: "#6b7280"
      primary: "#3b82f6"
      primary-foreground: "#ffffff"
      danger: "#ef4444"
      danger-foreground: "#ffffff"
    dark:
      surface: "#111827"
      surface-foreground: "#f9fafb"
      muted: "#1f2937"
      muted-foreground: "#9ca3af"
      primary: "#60a5fa"
      primary-foreground: "#111827"
      danger: "#f87171"
      danger-foreground: "#111827"
  container:
    center: true
    padding: "2rem"
    screens:
      sm: "640px"
      md: "768px"
      lg: "1024px"
      xl: "1280px"
      "2xl": "1536px"
screens:
  sm: 640
  md: 768
  lg: 1024
  xl: 1280
  2xl: 1536
semanticColors:
  surface: "#ffffff"
  surface-foreground: "#111827"
  muted: "#f3f4f6"
  muted-foreground: "#6b7280"
  primary: "#3b82f6"
  primary-foreground: "#ffffff"
  danger: "#ef4444"
  danger-foreground: "#ffffff"
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
  logger.i('Usage: flutter pub run flutterwind_core [command]');
  logger.i('Commands:');
  logger.i('  init     Initialize FlutterWind configuration');
  logger.i('  validate Validate className utilities/variants');
  logger.i('  matrix   Generate support matrix markdown');
  logger.i(parser.usage);
}

List<String> _tokenizeFlutterWindClasses(String classString) {
  final tokens = <String>[];
  final buffer = StringBuffer();
  var bracketDepth = 0;
  var parenDepth = 0;

  for (final rune in classString.runes) {
    final ch = String.fromCharCode(rune);
    if (ch == '[') {
      bracketDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ']') {
      if (bracketDepth > 0) bracketDepth--;
      buffer.write(ch);
      continue;
    }
    if (ch == '(') {
      parenDepth++;
      buffer.write(ch);
      continue;
    }
    if (ch == ')') {
      if (parenDepth > 0) parenDepth--;
      buffer.write(ch);
      continue;
    }

    final isWhitespace = ch.trim().isEmpty;
    if (isWhitespace && bracketDepth == 0 && parenDepth == 0) {
      final token = buffer.toString().trim();
      if (token.isNotEmpty) tokens.add(token);
      buffer.clear();
      continue;
    }
    buffer.write(ch);
  }

  final trailing = buffer.toString().trim();
  if (trailing.isNotEmpty) {
    tokens.add(trailing);
  }
  return tokens;
}

bool _isSupportedFlutterWindVariant(String variant) {
  return kFlutterWindSupportedVariants.contains(variant) ||
      kDefaultBreakpoints.containsKey(variant);
}

bool _isLikelySupportedFlutterWindUtility(String cls) {
  final normalized = cls.trim();
  return kFlutterWindSupportedExactUtilities.contains(normalized) ||
      kFlutterWindSupportedUtilityPrefixes.any(normalized.startsWith);
}

List<String> _suggestFlutterWindUtilities(String utility, {int maxResults = 3}) {
  final query = utility.trim();
  if (query.isEmpty) return const <String>[];
  final candidates = <String>[
    ...kFlutterWindSupportedExactUtilities,
    ...kFlutterWindSupportedUtilityPrefixes,
  ];
  return _nearestMatches(query, candidates, maxResults: maxResults);
}

List<String> _suggestFlutterWindVariants(String variant, {int maxResults = 3}) {
  final query = variant.trim();
  if (query.isEmpty) return const <String>[];
  final candidates = <String>[
    ...kFlutterWindSupportedVariants,
    ...kDefaultBreakpoints.keys,
  ];
  return _nearestMatches(query, candidates, maxResults: maxResults);
}

List<String> _nearestMatches(String query, List<String> candidates,
    {int maxResults = 3}) {
  final normalizedQuery = query.toLowerCase();
  final scored = <MapEntry<String, int>>[];
  final seen = <String>{};
  for (final candidate in candidates) {
    final key = candidate.toLowerCase();
    if (!seen.add(key)) continue;
    scored.add(MapEntry(candidate, _levenshteinDistance(normalizedQuery, key)));
  }
  scored.sort((a, b) {
    final distanceCompare = a.value.compareTo(b.value);
    if (distanceCompare != 0) return distanceCompare;
    return a.key.compareTo(b.key);
  });
  return scored
      .where((entry) => entry.value <= (query.length > 8 ? 5 : 3))
      .take(maxResults)
      .map((e) => e.key)
      .toList();
}

int _levenshteinDistance(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  final previous = List<int>.generate(b.length + 1, (i) => i);
  final current = List<int>.filled(b.length + 1, 0);
  for (var i = 1; i <= a.length; i++) {
    current[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final substitutionCost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      current[j] = [
        current[j - 1] + 1,
        previous[j] + 1,
        previous[j - 1] + substitutionCost,
      ].reduce((min, value) => value < min ? value : min);
    }
    for (var j = 0; j <= b.length; j++) {
      previous[j] = current[j];
    }
  }
  return previous[b.length];
}
