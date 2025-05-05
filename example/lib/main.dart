import 'package:example/home.dart';
import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';
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
            home: const HomePage(),
          ),
        );
      },
    );
  }
}
