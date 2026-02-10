import 'dart:async';

enum PerformanceProfile { minimal, standard, full }

class PerformanceEvent {
  final String name;
  final DateTime startTime;
  final Duration duration;
  final String type;
  final Map<String, dynamic> details;

  PerformanceEvent({
    required this.name,
    required this.startTime,
    required this.duration,
    required this.type,
    this.details = const {},
  });
}

class PerformanceProfiler {
  static final PerformanceProfiler _instance = PerformanceProfiler._internal();
  factory PerformanceProfiler() => _instance;
  PerformanceProfiler._internal();

  final _events = <PerformanceEvent>[];
  final _eventsController =
      StreamController<List<PerformanceEvent>>.broadcast();
  final _buildTimes = <String, List<Duration>>{};
  bool _isRecording = false;
  PerformanceProfile _profile = PerformanceProfile.standard;

  Stream<List<PerformanceEvent>> get eventsStream => _eventsController.stream;
  List<PerformanceEvent> get events => List.unmodifiable(_events);
  bool get isRecording => _isRecording;
  PerformanceProfile get profile => _profile;

  void setProfile(PerformanceProfile profile) {
    _profile = profile;
  }

  void startRecording() {
    _isRecording = true;
    _events.clear();
    _buildTimes.clear();
    _eventsController.add(_events);
  }

  void stopRecording() {
    _isRecording = false;
    _eventsController.add(_events);
  }

  void recordBuildTime(String widgetName, Duration duration) {
    if (!_isRecording) return;
    if (!_allowsType('build')) return;

    _buildTimes.putIfAbsent(widgetName, () => []).add(duration);

    final event = PerformanceEvent(
      name: widgetName,
      startTime: DateTime.now().subtract(duration),
      duration: duration,
      type: 'build',
      details: {
        'average': _calculateAverageBuildTime(widgetName),
        'count': _buildTimes[widgetName]!.length,
      },
    );

    _events.add(event);
    _eventsController.add(_events);
  }

  Duration _calculateAverageBuildTime(String widgetName) {
    final times = _buildTimes[widgetName];
    if (times == null || times.isEmpty) return Duration.zero;

    final total = times.fold<Duration>(
      Duration.zero,
      (prev, curr) => prev + curr,
    );
    return Duration(microseconds: total.inMicroseconds ~/ times.length);
  }

  void recordLayoutTime(String widgetName, Duration duration) {
    if (!_isRecording) return;
    if (!_allowsType('layout')) return;

    final event = PerformanceEvent(
      name: widgetName,
      startTime: DateTime.now().subtract(duration),
      duration: duration,
      type: 'layout',
    );

    _events.add(event);
    _eventsController.add(_events);
  }

  void recordPaintTime(String widgetName, Duration duration) {
    if (!_isRecording) return;
    if (!_allowsType('paint')) return;

    final event = PerformanceEvent(
      name: widgetName,
      startTime: DateTime.now().subtract(duration),
      duration: duration,
      type: 'paint',
    );

    _events.add(event);
    _eventsController.add(_events);
  }

  void clear() {
    _events.clear();
    _buildTimes.clear();
    _eventsController.add(_events);
  }

  bool _allowsType(String type) {
    switch (_profile) {
      case PerformanceProfile.minimal:
        return type == 'build';
      case PerformanceProfile.standard:
        return type == 'build' || type == 'layout';
      case PerformanceProfile.full:
        return true;
    }
  }
}
