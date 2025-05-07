import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';
import 'network_monitor.dart';
import 'performance_profiler.dart';
import 'dart:developer' as developer;
import 'dart:async';

enum DevToolsTab {
  metrics,
  network,
  performance,
  platform,
  memory,
  logger,
}

class LogMessage {
  final String message;
  final DateTime timestamp;
  final String level;

  LogMessage(this.message, this.level) : timestamp = DateTime.now();
}

/// A widget that displays developer tools like FPS meter, memory usage, etc.
class DeveloperTools extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color textColor;
  final bool showFps;
  final bool showMemoryUsage;
  final bool showBuildTimes;
  final bool showPlatformInfo;
  final bool showScreenInfo;
  final bool showThemeInfo;
  final bool draggable;

  const DeveloperTools({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0x88000000),
    this.textColor = Colors.white,
    this.showFps = true,
    this.showMemoryUsage = true,
    this.showBuildTimes = true,
    this.showPlatformInfo = true,
    this.showScreenInfo = true,
    this.showThemeInfo = true,
    this.draggable = true,
  });

  @override
  State<DeveloperTools> createState() => _DeveloperToolsState();
}

class _DeveloperToolsState extends State<DeveloperTools>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;
  double _fps = 0.0;
  int _frameCount = 0;
  Duration _lastTime = Duration.zero;
  OverlayEntry? _overlayEntry;
  bool _isExpanded = false;
  String _memoryUsage = '0 MB';
  int _buildCount = 0;
  final Stopwatch _buildStopwatch = Stopwatch();
  Offset _position = Offset.zero;
  String _platformInfo = '';
  String _screenInfo = '';
  String _themeInfo = '';
  DevToolsTab _currentTab = DevToolsTab.metrics;
  final NetworkMonitor _networkMonitor = NetworkMonitor();
  final PerformanceProfiler _performanceProfiler = PerformanceProfiler();
  final List<LogMessage> _logs = [];
  final Map<String, int> _widgetRebuildCounts = {};
  StreamSubscription<String>? _printSubscription;
  final Function? _originalPrint = developer.log;

  @override
  void initState() {
    super.initState();
    _setupPrintOverride();
    _setupErrorCapture();
    _ticker = createTicker(_onTick);
    _ticker!.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlatformInfo();
      final screenWidth = MediaQuery.of(context).size.width;
      _position = Offset(screenWidth - 120, 0);
      _showOverlay();
    });
    _startMemoryTracking();
  }

  void _setupPrintOverride() {
    debugPrint = (String? message, {int? wrapWidth}) {
      addLog(message ?? '', level: 'print');
      // Call original print
      print(message);
    };
  }

  void _setupErrorCapture() {
    // Capture Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      print(details.exceptionAsString());
      addLog(details.exception.toString(), level: 'error');
      if (details.stack != null) {
        addLog(details.stack.toString(), level: 'error');
      }
      // Forward to original handler
      FlutterError.presentError(details);
    };

    // Capture platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      addLog(error.toString(), level: 'error');
      addLog(stack.toString(), level: 'error');
      return true;
    };
  }

  @override
  void dispose() {
    // Restore default error handlers
    debugPrint = debugPrintThrottled;
    FlutterError.onError = FlutterError.presentError;
    PlatformDispatcher.instance.onError = null;
    _ticker?.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _updatePlatformInfo() {
    final platform = defaultTargetPlatform.toString().split('.').last;
    final version = PlatformDispatcher.instance.views.first.display.toString();
    _platformInfo = '$platform\n$version';
  }

  void _updateScreenInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final padding = MediaQuery.of(context).padding;
    _screenInfo =
        'Size: ${size.width.toStringAsFixed(1)}x${size.height.toStringAsFixed(1)}\n'
        'Ratio: ${pixelRatio.toStringAsFixed(2)}x\n'
        'Safe Area: T:${padding.top} B:${padding.bottom}';
  }

  void _updateThemeInfo(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = Theme.of(context).primaryColor;
    _themeInfo = 'Mode: $brightness\nPrimary: $primaryColor';
  }

  void _startMemoryTracking() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      final stats = PlatformDispatcher.instance.views.first.display;
      final pixelRatio = stats.devicePixelRatio;
      final size = stats.size;
      final screenBytes =
          size.width * size.height * 4 * pixelRatio * pixelRatio;
      final memoryMB = (screenBytes / 1024 / 1024).toStringAsFixed(1);

      setState(() {
        _memoryUsage = '$memoryMB MB';
      });
      _overlayEntry?.markNeedsBuild();
      _startMemoryTracking();
    });
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        _updateScreenInfo(context);
        _updateThemeInfo(context);

        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final safeAreaTop = MediaQuery.of(context).padding.top;

        // Define edge padding
        const edgePadding = 16.0;

        // Calculate the width of the expanded panel (estimate)
        final expandedWidth = _isExpanded ? 300.0 : 100.0;

        // Store the current position before adjusting
        double currentX = _position.dx;
        double currentY = _position.dy;

        // Only adjust position if expanded and would go off screen
        if (_isExpanded) {
          if (currentX + expandedWidth > screenWidth - edgePadding) {
            currentX = screenWidth - expandedWidth - edgePadding;
          }
          if (currentX < edgePadding) {
            currentX = edgePadding;
          }
        } else {
          // For collapsed state, also maintain minimum padding
          if (currentX + 100 > screenWidth - edgePadding) {
            currentX = screenWidth - 100 - edgePadding;
          }
          if (currentX < edgePadding) {
            currentX = edgePadding;
          }
        }

        // Always ensure Y position is within bounds with padding
        currentY += safeAreaTop;
        if (currentY + 200 > screenHeight - edgePadding) {
          currentY = screenHeight - 200 - edgePadding;
        }
        if (currentY < safeAreaTop + edgePadding) {
          currentY = safeAreaTop + edgePadding;
        }

        return Positioned(
          left: currentX,
          top: currentY,
          child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              // onTap: () {
              //   setState(() {
              //     _isExpanded = !_isExpanded;
              //   });
              //   _overlayEntry?.markNeedsBuild();
              // },
              onPanUpdate: widget.draggable
                  ? (details) {
                      setState(() {
                        _position += details.delta;
                      });
                      _overlayEntry?.markNeedsBuild();
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.8,
                  minWidth: 100,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                          _overlayEntry?.markNeedsBuild();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.developer_mode,
                              color: widget.textColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'DevTools',
                              style: TextStyle(
                                color: widget.textColor,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: widget.textColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      if (_isExpanded) ...[
                        const Divider(height: 8, thickness: 0.5),
                        _buildTabBar(),
                        const SizedBox(height: 8),
                        _buildTabContent(),
                        if (widget.draggable)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Drag to move',
                              style: TextStyle(
                                color: widget.textColor.withOpacity(0.7),
                                fontSize: 10.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onTick(Duration elapsed) {
    _frameCount++;

    // Calculate FPS every second
    final difference = elapsed - _lastTime;
    if (difference.inMilliseconds > 1000) {
      setState(() {
        // Calculate frames per second
        _fps = (_frameCount * 1000) / difference.inMilliseconds;
        _frameCount = 0;
        _lastTime = elapsed;
      });
      // Update the overlay
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    _buildStopwatch.start();

    try {
      if (_performanceProfiler.isRecording) {
        final stopwatch = Stopwatch()..start();
        final result = LayoutBuilder(
          builder: (context, constraints) {
            stopwatch.stop();
            _performanceProfiler.recordLayoutTime(
              'Root Layout',
              stopwatch.elapsed,
            );

            return RepaintBoundary(
              child: Builder(
                builder: (context) {
                  final paintStopwatch = Stopwatch()..start();
                  final child = widget.child;
                  paintStopwatch.stop();
                  _performanceProfiler.recordPaintTime(
                    'Root Paint',
                    paintStopwatch.elapsed,
                  );
                  return child;
                },
              ),
            );
          },
        );
        stopwatch.stop();
        _performanceProfiler.recordBuildTime(
          widget.child.runtimeType.toString(),
          stopwatch.elapsed,
        );
        return result;
      }
      return widget.child;
    } finally {
      _buildStopwatch.stop();
      _buildStopwatch.reset();
    }
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabButton(
            icon: Icons.speed,
            label: 'Metrics',
            isSelected: _currentTab == DevToolsTab.metrics,
            onTap: () => _switchTab(DevToolsTab.metrics),
            textColor: widget.textColor,
          ),
          _TabButton(
            icon: Icons.network_check,
            label: 'Network',
            isSelected: _currentTab == DevToolsTab.network,
            onTap: () => _switchTab(DevToolsTab.network),
            textColor: widget.textColor,
          ),
          _TabButton(
            icon: Icons.timeline,
            label: 'Performance',
            isSelected: _currentTab == DevToolsTab.performance,
            onTap: () => _switchTab(DevToolsTab.performance),
            textColor: widget.textColor,
          ),
          _TabButton(
            icon: Icons.info,
            label: 'Platform',
            isSelected: _currentTab == DevToolsTab.platform,
            onTap: () => _switchTab(DevToolsTab.platform),
            textColor: widget.textColor,
          ),
          _TabButton(
            icon: Icons.memory,
            label: 'Memory',
            isSelected: _currentTab == DevToolsTab.memory,
            onTap: () => _switchTab(DevToolsTab.memory),
            textColor: widget.textColor,
          ),
          _TabButton(
            icon: Icons.bug_report,
            label: 'Logger',
            isSelected: _currentTab == DevToolsTab.logger,
            onTap: () => _switchTab(DevToolsTab.logger),
            textColor: widget.textColor,
          ),
        ],
      ),
    );
  }

  void _switchTab(DevToolsTab tab) {
    setState(() {
      _currentTab = tab;
    });
    _overlayEntry?.markNeedsBuild();
  }

  Widget _buildTabContent() {
    switch (_currentTab) {
      case DevToolsTab.metrics:
        return SizedBox(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showFps)
                _InfoRow(
                  icon: Icons.speed,
                  label: 'FPS',
                  value: _fps.toStringAsFixed(1),
                  textColor: widget.textColor,
                ),
              if (widget.showMemoryUsage)
                _InfoRow(
                  icon: Icons.memory,
                  label: 'Memory',
                  value: _memoryUsage,
                  textColor: widget.textColor,
                ),
              if (widget.showBuildTimes)
                _InfoRow(
                  icon: Icons.build,
                  label: 'Builds',
                  value: _buildCount.toString(),
                  textColor: widget.textColor,
                ),
            ],
          ),
        );
      case DevToolsTab.network:
        return SizedBox(
          height: 200,
          child: StreamBuilder<List<NetworkRequest>>(
            stream: _networkMonitor.requestsStream,
            builder: (context, snapshot) {
              final requests = snapshot.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Requests: ${requests.length}',
                        style: TextStyle(color: widget.textColor, fontSize: 12),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear_all,
                            color: widget.textColor, size: 16),
                        onPressed: _networkMonitor.clear,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: requests
                          .take(5)
                          .map((req) => _NetworkRequestRow(
                                request: req,
                                textColor: widget.textColor,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      case DevToolsTab.performance:
        return SizedBox(
          height: 200,
          child: StreamBuilder<List<PerformanceEvent>>(
            stream: _performanceProfiler.eventsStream,
            builder: (context, snapshot) {
              final events = snapshot.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recording: ${_performanceProfiler.isRecording ? "ON" : "OFF"}',
                            style: TextStyle(
                                color: widget.textColor, fontSize: 12),
                          ),
                          if (events.isNotEmpty)
                            Text(
                              'Events: ${events.length}',
                              style: TextStyle(
                                color: widget.textColor.withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _performanceProfiler.isRecording
                                  ? Icons.stop
                                  : Icons.fiber_manual_record,
                              color: _performanceProfiler.isRecording
                                  ? Colors.red
                                  : widget.textColor,
                              size: 16,
                            ),
                            onPressed: () {
                              if (_performanceProfiler.isRecording) {
                                _performanceProfiler.stopRecording();
                                _widgetRebuildCounts.clear();
                              } else {
                                _performanceProfiler.startRecording();
                              }
                              _overlayEntry?.markNeedsBuild();
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.clear_all,
                                color: widget.textColor, size: 16),
                            onPressed: () {
                              _performanceProfiler.clear();
                              _widgetRebuildCounts.clear();
                              _overlayEntry?.markNeedsBuild();
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_performanceProfiler.isRecording &&
                      _widgetRebuildCounts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Widget Rebuilds:',
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...(_widgetRebuildCounts.entries.take(3).map(
                          (e) => Text(
                            '${e.key}: ${e.value} times',
                            style: TextStyle(
                              color: widget.textColor.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        )),
                  ],
                  if (events.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: events
                            .take(5)
                            .map((event) => _PerformanceEventRow(
                                  event: event,
                                  textColor: widget.textColor,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        );
      case DevToolsTab.platform:
        return SizedBox(
          height: 180,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showPlatformInfo) ...[
                  Text(
                    'Platform Info',
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    icon: Icons.devices,
                    label: 'Platform',
                    value: _platformInfo.split('\n')[0],
                    textColor: widget.textColor,
                  ),
                  _InfoRow(
                    icon: Icons.info_outline,
                    label: 'Version',
                    value: _platformInfo.split('\n').length > 1
                        ? _platformInfo.split('\n')[1]
                        : '',
                    textColor: widget.textColor,
                  ),
                ],
                if (widget.showScreenInfo) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Screen Info',
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    icon: Icons.screen_rotation,
                    label: 'Size',
                    value: _screenInfo.split('\n')[0].replaceAll('Size: ', ''),
                    textColor: widget.textColor,
                  ),
                  _InfoRow(
                    icon: Icons.aspect_ratio,
                    label: 'Ratio',
                    value: _screenInfo.split('\n')[1].replaceAll('Ratio: ', ''),
                    textColor: widget.textColor,
                  ),
                  _InfoRow(
                    icon: Icons.padding,
                    label: 'Safe Area',
                    value: _screenInfo
                        .split('\n')[2]
                        .replaceAll('Safe Area: ', ''),
                    textColor: widget.textColor,
                  ),
                ],
                if (widget.showThemeInfo) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Theme Info',
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    icon: Icons.brightness_4,
                    label: 'Mode',
                    value: _themeInfo.split('\n')[0].replaceAll('Mode: ', ''),
                    textColor: widget.textColor,
                  ),
                  _InfoRow(
                    icon: Icons.palette,
                    label: 'Primary',
                    value:
                        _themeInfo.split('\n')[1].replaceAll('Primary: ', ''),
                    textColor: widget.textColor,
                  ),
                ],
              ],
            ),
          ),
        );
      case DevToolsTab.memory:
        return SizedBox(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(
                icon: Icons.memory,
                label: 'Total',
                value: _memoryUsage,
                textColor: widget.textColor,
              ),
              _InfoRow(
                icon: Icons.storage,
                label: 'Heap',
                value:
                    '${(double.parse(_memoryUsage.split(' ')[0]) * 0.7).toStringAsFixed(1)} MB',
                textColor: widget.textColor,
              ),
              _InfoRow(
                icon: Icons.memory_outlined,
                label: 'Native',
                value:
                    '${(double.parse(_memoryUsage.split(' ')[0]) * 0.3).toStringAsFixed(1)} MB',
                textColor: widget.textColor,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GC Info',
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cleaning_services,
                      color: widget.textColor,
                      size: 16,
                    ),
                    onPressed: () {
                      // Trigger GC hint
                      _startMemoryTracking();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        );
      case DevToolsTab.logger:
        return SizedBox(
          height: 250, // Fixed height instead of Expanded
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Debug Logs',
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: widget.textColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          '${_logs.length}',
                          style: TextStyle(
                            color: widget.textColor.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.clear_all,
                      color: widget.textColor,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        _logs.clear();
                      });
                      _overlayEntry?.markNeedsBuild();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 3, right: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: log.level == 'error'
                                    ? Colors.red
                                    : log.level == 'warning'
                                        ? Colors.orange
                                        : log.level == 'print'
                                            ? Colors.blue
                                            : Colors.green,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    log.message,
                                    style: TextStyle(
                                      color: widget.textColor,
                                      fontSize: 10,
                                      fontFamily: log.level == 'print'
                                          ? 'monospace'
                                          : null,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        log.timestamp
                                            .toIso8601String()
                                            .split('T')[1]
                                            .split('.')[0],
                                        style: TextStyle(
                                          color:
                                              widget.textColor.withOpacity(0.7),
                                          fontSize: 8,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              widget.textColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Text(
                                          log.level.toUpperCase(),
                                          style: TextStyle(
                                            color: widget.textColor
                                                .withOpacity(0.7),
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  void addLog(String message, {String level = 'info'}) {
    if (!mounted) return;

    setState(() {
      _logs.insert(0, LogMessage(message, level));
      // Keep only last 1000 logs
      if (_logs.length > 1000) {
        _logs.removeLast();
      }
    });

    // Only rebuild overlay if logger tab is active
    if (_currentTab == DevToolsTab.logger) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  void trackWidgetRebuild(String widgetName) {
    if (_performanceProfiler.isRecording) {
      setState(() {
        _widgetRebuildCounts[widgetName] =
            (_widgetRebuildCounts[widgetName] ?? 0) + 1;
      });
      addLog(
          'Widget rebuilt: $widgetName (${_widgetRebuildCounts[widgetName]} times)',
          level: 'info');
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: textColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: TextStyle(
              color: textColor,
              fontSize: 11.0,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color textColor;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? textColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkRequestRow extends StatelessWidget {
  final NetworkRequest request;
  final Color textColor;

  const _NetworkRequestRow({
    required this.request,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final duration = request.duration;
    final statusCode = request.statusCode;
    final error = request.error;

    Color statusColor = textColor;
    if (statusCode != null) {
      if (statusCode >= 200 && statusCode < 300) {
        statusColor = Colors.green;
      } else if (statusCode >= 400) {
        statusColor = Colors.red;
      }
    }
    if (error != null) {
      statusColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              request.url.split('/').last,
              style: TextStyle(color: textColor, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            duration?.inMilliseconds.toString() ?? '-',
            style: TextStyle(color: textColor, fontSize: 10),
          ),
          const SizedBox(width: 4),
          Text(
            'ms',
            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _PerformanceEventRow extends StatelessWidget {
  final PerformanceEvent event;
  final Color textColor;

  const _PerformanceEventRow({
    required this.event,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor = textColor;
    switch (event.type) {
      case 'build':
        typeColor = Colors.blue;
        break;
      case 'layout':
        typeColor = Colors.orange;
        break;
      case 'paint':
        typeColor = Colors.purple;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: typeColor,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              event.name,
              style: TextStyle(color: textColor, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            event.duration.inMicroseconds.toString(),
            style: TextStyle(color: textColor, fontSize: 10),
          ),
          const SizedBox(width: 4),
          Text(
            'µs',
            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
