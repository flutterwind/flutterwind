import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/flutterwind.dart';

void main() {
  testWidgets('benchmark: variant resolution path', (tester) async {
    final widget = MaterialApp(
      home: Scaffold(
        body: Container().className(
          'bg-blue-500 hover:bg-red-500 focus:bg-green-500 active:bg-yellow-500 '
          'group-hover:text-white peer-hover:text-black',
        ),
      ),
    );

    final sw = Stopwatch()..start();
    for (var i = 0; i < 200; i++) {
      await tester.pumpWidget(widget);
      await tester.pump();
    }
    sw.stop();

    expect(sw.elapsedMilliseconds, lessThan(3000));
  });
}
