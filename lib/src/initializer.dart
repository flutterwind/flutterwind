import 'package:flutter/material.dart';
import 'package:flutterwinds/src/config/config_loader.dart';
import 'package:flutterwinds/src/utils/logger.dart';

/// FlutterWindInitializer is a widget that loads the Tailwind configuration
/// asynchronously. Wrap your app with this widget to auto-load configuration.
class FlutterWind extends StatefulWidget {
  final Widget child;
  const FlutterWind({super.key, required this.child});

  @override
  State<FlutterWind> createState() => _FlutterWindState();
}

class _FlutterWindState extends State<FlutterWind> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() async {
    try {
      await ConfigLoader.loadConfig();
      setState(() {
        _isLoaded = true;
      });
    } catch (e, stackTrace) {
      // You may use your logging mechanism here.
      Log.e('Error loading configuration', e, stackTrace);
      setState(() {
        _isLoaded = true; // continue even if error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    return widget.child;
  }
}
