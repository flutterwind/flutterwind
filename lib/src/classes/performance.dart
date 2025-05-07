import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PerformanceClass {
  // Lazy loading presets
  static const Map<String, bool> lazyLoadValues = {
    'lazy-load': true,
    'eager-load': false,
  };

  // Caching presets
  static const Map<String, bool> cacheValues = {
    'cache': true,
    'no-cache': false,
  };

  // Memory optimization presets
  static const Map<String, bool> memoryOptimizationValues = {
    'optimize-memory': true,
    'no-optimize-memory': false,
  };

  // Image optimization presets
  static const Map<String, String> imageOptimizationValues = {
    'optimize-image': 'auto',
    'optimize-image-quality': 'quality',
    'optimize-image-size': 'size',
  };

  // Widget recycling presets
  static const Map<String, bool> widgetRecyclingValues = {
    'recycle-widgets': true,
    'no-recycle-widgets': false,
  };

  // Debounce presets
  static const Map<String, int> debounceValues = {
    'debounce-100': 100,
    'debounce-200': 200,
    'debounce-300': 300,
    'debounce-500': 500,
    'debounce-1000': 1000,
  };

  // Throttle presets
  static const Map<String, int> throttleValues = {
    'throttle-100': 100,
    'throttle-200': 200,
    'throttle-300': 300,
    'throttle-500': 500,
    'throttle-1000': 1000,
  };

  static final Map<String, Widget> _widgetCache = {};
  static final Set<String> _visibleWidgets = {};

  static void apply(String cls, FlutterWindStyle style) {
    if (lazyLoadValues.containsKey(cls)) {
      _applyLazyLoad(cls, style);
    } else if (cacheValues.containsKey(cls)) {
      _applyCache(cls, style);
    } else if (memoryOptimizationValues.containsKey(cls)) {
      _applyMemoryOptimization(cls, style);
    } else if (imageOptimizationValues.containsKey(cls)) {
      _applyImageOptimization(cls, style);
    } else if (widgetRecyclingValues.containsKey(cls)) {
      _applyWidgetRecycling(cls, style);
    } else if (debounceValues.containsKey(cls)) {
      _applyDebounce(cls, style);
    } else if (throttleValues.containsKey(cls)) {
      _applyThrottle(cls, style);
    }
  }

  static void _applyLazyLoad(String cls, FlutterWindStyle style) {
    if (lazyLoadValues.containsKey(cls)) {
      style.lazyLoad = lazyLoadValues[cls];
    }
  }

  static void _applyCache(String cls, FlutterWindStyle style) {
    if (cacheValues.containsKey(cls)) {
      style.cache = cacheValues[cls];
    }
  }

  static void _applyMemoryOptimization(String cls, FlutterWindStyle style) {
    if (memoryOptimizationValues.containsKey(cls)) {
      style.memoryOptimization = memoryOptimizationValues[cls];
    }
  }

  static void _applyImageOptimization(String cls, FlutterWindStyle style) {
    if (imageOptimizationValues.containsKey(cls)) {
      style.imageOptimization = imageOptimizationValues[cls];
    }
  }

  static void _applyWidgetRecycling(String cls, FlutterWindStyle style) {
    if (widgetRecyclingValues.containsKey(cls)) {
      style.widgetRecycling = widgetRecyclingValues[cls];
    }
  }

  static void _applyDebounce(String cls, FlutterWindStyle style) {
    if (debounceValues.containsKey(cls)) {
      style.debounce = debounceValues[cls];
    }
  }

  static void _applyThrottle(String cls, FlutterWindStyle style) {
    if (throttleValues.containsKey(cls)) {
      style.throttle = throttleValues[cls];
    }
  }

  // static Widget applyWidget(String className, Widget child) {
  //   if (className == 'widget-recycle') {
  //     return _RecycledWidget(child: child);
  //   } else if (className == 'memory-optimize') {
  //     return _MemoryOptimizedWidget(child: child);
  //   } else if (className == 'lazy-load') {
  //     return _LazyLoadedWidget(child: child);
  //   }
  //   return child;
  // }
}

class _RecycledWidget extends StatefulWidget {
  final Widget child;

  const _RecycledWidget({required this.child});

  @override
  State<_RecycledWidget> createState() => _RecycledWidgetState();
}

class _RecycledWidgetState extends State<_RecycledWidget> {
  String? _cacheKey;

  @override
  void initState() {
    super.initState();
    _cacheKey = widget.child.toString();
    PerformanceClass._visibleWidgets.add(_cacheKey!);
  }

  @override
  void dispose() {
    PerformanceClass._visibleWidgets.remove(_cacheKey);
    if (PerformanceClass._visibleWidgets.length <
        PerformanceClass._widgetCache.length * 0.7) {
      _cleanupCache();
    }
    super.dispose();
  }

  void _cleanupCache() {
    PerformanceClass._widgetCache.removeWhere(
      (key, _) => !PerformanceClass._visibleWidgets.contains(key),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cacheKey != null &&
        PerformanceClass._widgetCache.containsKey(_cacheKey)) {
      return PerformanceClass._widgetCache[_cacheKey]!;
    }

    final optimizedWidget = _MemoryOptimizedWidget(child: widget.child);
    if (_cacheKey != null) {
      PerformanceClass._widgetCache[_cacheKey!] = optimizedWidget;
    }
    return optimizedWidget;
  }
}

class _MemoryOptimizedWidget extends StatelessWidget {
  final Widget child;

  const _MemoryOptimizedWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: child,
    );
  }
}

class _LazyLoadedWidget extends StatefulWidget {
  final Widget child;

  const _LazyLoadedWidget({required this.child});

  @override
  State<_LazyLoadedWidget> createState() => _LazyLoadedWidgetState();
}

class _LazyLoadedWidgetState extends State<_LazyLoadedWidget> {
  bool _isVisible = false;
  final _key = GlobalKey();
  Timer? _visibilityTimer;

  @override
  void initState() {
    super.initState();
    _scheduleVisibilityCheck();
  }

  @override
  void dispose() {
    _visibilityTimer?.cancel();
    super.dispose();
  }

  void _scheduleVisibilityCheck() {
    _visibilityTimer?.cancel();
    _visibilityTimer = Timer(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      _scheduleVisibilityCheck();
      return;
    }

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    final isVisible = position.dx + size.width >= -100 &&
        position.dx <= screenSize.width + 100 &&
        position.dy + size.height >= -100 &&
        position.dy <= screenSize.height + 100;

    if (isVisible != _isVisible) {
      setState(() {
        _isVisible = isVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          _scheduleVisibilityCheck();
        }
        return false;
      },
      child: KeyedSubtree(
        key: _key,
        child: _isVisible ? widget.child : const SizedBox(),
      ),
    );
  }
}
