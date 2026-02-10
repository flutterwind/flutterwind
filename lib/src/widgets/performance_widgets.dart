import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutterwind_core/flutterwind.dart';

class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final Key key;
  final Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({
    required this.child,
    required this.key,
    required this.onVisibilityChanged,
  });

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenSize = MediaQuery.of(context).size;

      final visible = position.dx + size.width > 0 &&
          position.dx < screenSize.width &&
          position.dy + size.height > 0 &&
          position.dy < screenSize.height;

      widget.onVisibilityChanged(VisibilityInfo(
        visibleFraction: visible ? 1.0 : 0.0,
        size: size,
        position: position,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class VisibilityInfo {
  final double visibleFraction;
  final Size size;
  final Offset position;

  VisibilityInfo({
    required this.visibleFraction,
    required this.size,
    required this.position,
  });
}

class Cache extends StatelessWidget {
  final Widget child;

  const Cache({required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: child,
    );
  }
}

class MemoryOptimized extends StatefulWidget {
  final Widget child;

  const MemoryOptimized({required this.child});

  @override
  State<MemoryOptimized> createState() => _MemoryOptimizedState();
}

class _MemoryOptimizedState extends State<MemoryOptimized>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Avoid retaining offscreen list items and isolate repaints.
    return RepaintBoundary(
      child: widget.child,
    );
  }
}

class ImageOptimized extends StatelessWidget {
  final String optimizationMode;
  final Widget child;

  const ImageOptimized({
    required this.optimizationMode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (child is Image) {
          final image = child as Image;
          return Image(
            image: image.image,
            width: image.width,
            height: image.height,
            fit: image.fit,
            alignment: image.alignment,
            repeat: image.repeat,
            centerSlice: image.centerSlice,
            matchTextDirection: image.matchTextDirection,
            gaplessPlayback: image.gaplessPlayback,
            filterQuality: optimizationMode == 'quality'
                ? FilterQuality.high
                : FilterQuality.low,
            isAntiAlias: image.isAntiAlias,
          );
        }
        return child;
      },
    );
  }
}

class RecycledWidget extends StatefulWidget {
  final Widget child;

  const RecycledWidget({required this.child});

  @override
  State<RecycledWidget> createState() => _RecycledWidgetState();
}

class _RecycledWidgetState extends State<RecycledWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class Debounced extends StatefulWidget {
  final Duration duration;
  final Widget child;

  const Debounced({
    required this.duration,
    required this.child,
  });

  @override
  State<Debounced> createState() => _DebouncedState();
}

class _DebouncedState extends State<Debounced> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _debounce(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(widget.duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Notification>(
      onNotification: (notification) {
        _debounce(() {
          // Handle debounced notification
        });
        return true;
      },
      child: widget.child,
    );
  }
}

class Throttled extends StatefulWidget {
  final Duration duration;
  final Widget child;

  const Throttled({
    required this.duration,
    required this.child,
  });

  @override
  State<Throttled> createState() => _ThrottledState();
}

class _ThrottledState extends State<Throttled> {
  DateTime? _lastExecution;

  void _throttle(VoidCallback callback) {
    final now = DateTime.now();
    if (_lastExecution == null ||
        now.difference(_lastExecution!) > widget.duration) {
      _lastExecution = now;
      callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Notification>(
      onNotification: (notification) {
        _throttle(() {
          // Handle throttled notification
        });
        return true;
      },
      child: widget.child,
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class LazyLoadWrapper extends StatefulWidget {
  final Widget child;

  const LazyLoadWrapper({
    required Key key,
    required this.child,
  }) : super(key: key);

  @override
  State<LazyLoadWrapper> createState() => _LazyLoadWrapperState();
}

class _LazyLoadWrapperState extends State<LazyLoadWrapper> {
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

    // Calculate the visible area
    final visibleWidth = (position.dx + size.width).clamp(0, screenSize.width) -
        position.dx.clamp(0, screenSize.width);
    final visibleHeight =
        (position.dy + size.height).clamp(0, screenSize.height) -
            position.dy.clamp(0, screenSize.height);

    // Consider the widget visible if at least 50% of its area is visible
    final isVisible =
        (visibleWidth * visibleHeight) / (size.width * size.height) > 0.5;

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
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification) {
          _scheduleVisibilityCheck();
        }
        return false;
      },
      child: KeyedSubtree(
        key: _key,
        child: _isVisible
            ? widget.child
            : ShimmerEffect(
                width: widget.child is Image
                    ? (widget.child as Image).width ?? 100
                    : 100,
                height: widget.child is Image
                    ? (widget.child as Image).height ?? 100
                    : 100,
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
              ),
      ),
    );
  }
}
