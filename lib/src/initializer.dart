import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';
import 'package:flutterwind_core/src/config/config_loader.dart';
import 'package:flutterwind_core/src/utils/logger.dart';

/// FlutterWindInitializer is a widget that loads the Tailwind configuration
/// asynchronously. Wrap your app with this widget to auto-load configuration.
class FlutterWind extends StatefulWidget {
  final Widget child;
  final Widget? loadingWidget;
  const FlutterWind({
    super.key,
    required this.child,
    this.loadingWidget,
  });

  @override
  State<FlutterWind> createState() => _FlutterWindState();
}

class _FlutterWindState extends State<FlutterWind> with WidgetsBindingObserver {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() async {
    try {
      await ConfigLoader.loadConfig();
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
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
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }
    return MediaQuery(
      // Create a new MediaQuery that will rebuild on size changes
      data: MediaQuery.of(context).copyWith(),
      child: widget.child,
    );
  }
}
