import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/config/config_loader.dart';
import 'package:flutterwind_core/src/utils/logger.dart';
import 'package:flutterwind_core/src/utils/developer_tools.dart';

/// FlutterWindInitializer is a widget that loads the Tailwind configuration
/// asynchronously. Wrap your app with this widget to auto-load configuration.
class FlutterWind extends StatefulWidget {
  final Widget? child;
  final Widget? loadingWidget;
  final bool showDevTools;
  final Color? devToolsBackgroundColor;
  final Color? devToolsTextColor;
  final bool showFps;
  final bool showMemoryUsage;
  final bool showBuildTimes;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final String? title;
  final Color? color;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale>? supportedLocales;
  final bool debugShowCheckedModeBanner;
  final bool debugShowMaterialGrid;
  final bool useInheritedMediaQuery;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;
  final Widget? home;
  final String? initialRoute;
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;
  final Route<dynamic> Function(RouteSettings)? onGenerateRoute;

  const FlutterWind({
    super.key,
    this.child,
    this.loadingWidget,
    this.showDevTools = false,
    this.devToolsBackgroundColor,
    this.devToolsTextColor,
    this.showFps = true,
    this.showMemoryUsage = true,
    this.showBuildTimes = true,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.title,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales,
    this.debugShowCheckedModeBanner = false,
    this.debugShowMaterialGrid = false,
    this.useInheritedMediaQuery = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.home,
    this.initialRoute,
    this.onGenerateInitialRoutes,
    this.onGenerateRoute,
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

    Widget child = widget.child ?? widget.home ?? const SizedBox.shrink();

    if (widget.showDevTools) {
      child = DeveloperTools(
        backgroundColor:
            widget.devToolsBackgroundColor ?? const Color(0x88000000),
        textColor: widget.devToolsTextColor ?? Colors.white,
        showFps: widget.showFps,
        showMemoryUsage: widget.showMemoryUsage,
        showBuildTimes: widget.showBuildTimes,
        child: child,
      );
    }

    return MaterialApp(
      title: widget.title ?? '',
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode,
      color: widget.color,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      supportedLocales: widget.supportedLocales ?? const [Locale('en', 'US')],
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      debugShowMaterialGrid: widget.debugShowMaterialGrid,
      useInheritedMediaQuery: widget.useInheritedMediaQuery,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
      scrollBehavior: widget.scrollBehavior,
      initialRoute: widget.initialRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onGenerateRoute: widget.onGenerateRoute,
      home: MediaQuery(
        // Create a new MediaQuery that will rebuild on size changes
        data: MediaQuery.of(context).copyWith(),
        child: child,
      ),
    );
  }
}
