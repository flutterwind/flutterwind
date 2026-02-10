import 'package:flutterwind_core/src/plugin/class_handler.dart';

class FlutterWindClassHandlerRegistry {
  static final List<FlutterWindClassHandler> _handlers =
      <FlutterWindClassHandler>[];

  static List<FlutterWindClassHandler> get handlers =>
      (List<FlutterWindClassHandler>.from(_handlers)
        ..sort((a, b) => a.order.compareTo(b.order)));

  static bool get isEmpty => _handlers.isEmpty;

  static void clear() {
    _handlers.clear();
  }

  static void register(FlutterWindClassHandler handler) {
    _handlers.removeWhere((existing) => existing.name == handler.name);
    _handlers.add(handler);
  }
}
