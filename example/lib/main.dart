import 'package:example/filter_effects_example.dart';
import 'package:example/input_examples.dart';
import 'package:example/interactive_transform_demo.dart';
import 'package:example/transform_examples.dart';
import 'package:example/all_classes_showcase.dart';
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
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isFlutterWindReady = false;

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
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                'Developer Tools ${devToolsEnabled.value ? 'Enabled' : 'Disabled'}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
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
            // Custom splash/loading screen
            loadingWidget: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.dark,
                useMaterial3: true,
              ),
              home: Scaffold(
                backgroundColor: Colors.deepPurple.shade900,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wind_power,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'FlutterWind',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading configuration...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Callback when initialization completes
            onInitComplete: () {
              setState(() {
                _isFlutterWindReady = true;
              });
            },
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
            themeMode: _themeMode,
            home: ExamplesHome(
              themeMode: _themeMode,
              onToggleTheme: () {
                setState(() {
                  _themeMode = _themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                });
              },
              onToggleDevTools: (ctx) => _toggleDevTools(ctx),
            ),
          ),
        );
      },
    );
  }
}

class ExamplesHome extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final ValueChanged<BuildContext> onToggleDevTools;

  const ExamplesHome({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onToggleDevTools,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterWind Examples'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: devToolsEnabled,
            builder: (context, enabled, child) {
              return IconButton(
                tooltip: enabled
                    ? 'Hide Developer Tools'
                    : 'Show Developer Tools',
                onPressed: () => onToggleDevTools(context),
                icon: Icon(
                  enabled ? Icons.bug_report : Icons.bug_report_outlined,
                ),
              );
            },
          ),
          IconButton(
            tooltip: themeMode == ThemeMode.dark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: onToggleTheme,
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
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
              MaterialPageRoute(builder: (context) => example.page),
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
    title: 'All Classes Showcase',
    description: 'Comprehensive utility and variant coverage in one page',
    page: AllClassesShowcase(),
  ),
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
