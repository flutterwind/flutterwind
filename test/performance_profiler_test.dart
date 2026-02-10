import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/src/utils/performance_profiler.dart';

void main() {
  group('performance profiler profiles', () {
    test('minimal profile records only build events', () {
      final profiler = PerformanceProfiler();
      profiler.clear();
      profiler.setProfile(PerformanceProfile.minimal);
      profiler.startRecording();

      profiler.recordBuildTime('WidgetA', const Duration(milliseconds: 1));
      profiler.recordLayoutTime('WidgetA', const Duration(milliseconds: 2));
      profiler.recordPaintTime('WidgetA', const Duration(milliseconds: 3));
      profiler.stopRecording();

      expect(profiler.events.length, 1);
      expect(profiler.events.first.type, 'build');
    });

    test('full profile records build layout and paint', () {
      final profiler = PerformanceProfiler();
      profiler.clear();
      profiler.setProfile(PerformanceProfile.full);
      profiler.startRecording();

      profiler.recordBuildTime('WidgetA', const Duration(milliseconds: 1));
      profiler.recordLayoutTime('WidgetA', const Duration(milliseconds: 2));
      profiler.recordPaintTime('WidgetA', const Duration(milliseconds: 3));
      profiler.stopRecording();

      final types = profiler.events.map((e) => e.type).toList();
      expect(types, containsAll(<String>['build', 'layout', 'paint']));
    });

    test('profile setting persists on singleton instance', () {
      final profiler = PerformanceProfiler();
      profiler.setProfile(PerformanceProfile.full);

      final anotherRef = PerformanceProfiler();
      expect(anotherRef.profile, PerformanceProfile.full);
    });
  });
}
