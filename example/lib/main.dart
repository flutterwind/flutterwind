import 'package:example/filter_effects_example.dart';
import 'package:example/input_examples.dart';
import 'package:example/interactive_transform_demo.dart';
import 'package:example/transform_examples.dart';
import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';
import 'typography_examples.dart';
import 'layout_examples.dart';
import 'animation_examples.dart';
import 'transition_examples.dart';
import 'accessibility_examples.dart';
import 'performance_examples.dart';
import 'advanced_effects_examples.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Create a global ValueNotifier for developer tools state
final ValueNotifier<bool> devToolsEnabled = ValueNotifier<bool>(false);

void main() async {
  // Ensure platform channels are properly initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the initial state from persistent storage
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    devToolsEnabled.value = prefs.getBool('devToolsEnabled') ?? false;
  } catch (e) {
    // If shared preferences fails, default to false
    debugPrint('Failed to load developer tools state: $e');
    devToolsEnabled.value = false;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Secret gesture counter
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleSecretGesture(BuildContext context) {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCount = 0;
    }
    _lastTapTime = now;

    _tapCount++;
    if (_tapCount >= 5) {
      // Require 5 rapid taps
      _tapCount = 0;
      _toggleDevTools(context);
    }
  }

  Future<void> _toggleDevTools(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      devToolsEnabled.value = !devToolsEnabled.value;
      await prefs.setBool('devToolsEnabled', devToolsEnabled.value);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Developer Tools ${devToolsEnabled.value ? 'Enabled' : 'Disabled'}',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to save developer tools state: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: devToolsEnabled,
      builder: (context, enabled, child) {
        return GestureDetector(
          onTap: () => _handleSecretGesture(context),
          behavior: HitTestBehavior.translucent,
          child: FlutterWind(
            showDevTools: enabled,
            title: 'FlutterWind Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: ThemeMode.light,
            home: const ExamplesHome(),
          ),
        );
      },
    );
  }
}

class ExamplesHome extends StatelessWidget {
  const ExamplesHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterWind Examples'),
      ),
      body: ListView.builder(
        itemCount: _examples.length,
        itemBuilder: (context, index) {
          final example = _examples[index];
          return ListTile(
            title: Text(example.title),
            subtitle: Text(example.description),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => example.page,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Example {
  final String title;
  final String description;
  final Widget page;

  const Example({
    required this.title,
    required this.description,
    required this.page,
  });
}

final List<Example> _examples = [
  const Example(
    title: 'Typography',
    description: 'Text styling, effects, and formatting examples',
    page: TypographyExamples(),
  ),
  const Example(
    title: 'Layout',
    description: 'Grid, flex, and spacing examples',
    page: LayoutExamples(),
  ),
  const Example(
    title: 'Animations',
    description: 'Basic and advanced animation examples',
    page: AnimationExamples(),
  ),
  const Example(
    title: 'Transitions',
    description: 'Page and widget transition examples',
    page: TransitionExamples(),
  ),
  const Example(
    title: 'Input',
    description: 'Semantics and accessibility features',
    page: InputExamples(),
  ),
  const Example(
    title: 'Accessibility',
    description: 'Semantics and accessibility features',
    page: AccessibilityExamples(),
  ),
  const Example(
    title: 'Performance',
    description: 'Optimization and performance features',
    page: PerformanceExamples(),
  ),
  const Example(
    title: 'Advanced Effects',
    description: 'Filters, blend modes, and shaders',
    page: AdvancedEffectsExamples(),
  ),
  const Example(
    title: 'Interactive Transform',
    description: 'Interactive transform examples',
    page: InteractiveTransformDemo(),
  ),
  const Example(
    title: 'Filter Effects',
    description: 'Filters, blend modes, and shaders',
    page: FilterEffectsDemo(),
  ),
  const Example(
    title: 'Transform Examples',
    description: 'Transform examples',
    page: TransformExamplesPage(),
  ),
];
