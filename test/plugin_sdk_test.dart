import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/flutterwind.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

void main() {
  test('plugin sdk registers custom utility handler', () {
    registerFlutterWindUtilityHandler(
      FlutterWindClassHandler(
        name: 'test_plugin_handler',
        order: 999,
        apply: (cls, style) {
          if (cls == 'plugin-opacity') {
            (style as FlutterWindStyle).opacity = 0.42;
          }
        },
      ),
    );

    final style = FlutterWindStyle();
    applyClassToStyle('plugin-opacity', style);
    expect(style.opacity, closeTo(0.42, 0.0001));
  });
}
