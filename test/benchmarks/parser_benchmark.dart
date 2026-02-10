import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

void main() {
  test('benchmark: tokenize and apply class list', () {
    const classString =
        'p-4 m-2 bg-blue-500 text-white rounded-lg shadow hover:bg-red-500 '
        'focus:outline-none md:p-6 lg:p-8 transition-all duration-300';

    final sw = Stopwatch()..start();
    for (var i = 0; i < 1000; i++) {
      final tokens = tokenizeFlutterWindClasses(classString);
      final style = FlutterWindStyle();
      for (final token in tokens) {
        applyClassToStyle(token, style);
      }
    }
    sw.stop();

    // Ensure benchmark executes and remains in a reasonable local range.
    expect(sw.elapsedMilliseconds, lessThan(2000));
  });
}
