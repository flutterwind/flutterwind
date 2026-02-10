import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

void main() {
  test('tokenizer keeps arbitrary values intact', () {
    final classes = tokenizeFlutterWindClasses(
      'w-[10rem] bg-[#123456] shadow-lg md:hover:bg-red-500',
    );

    expect(
      classes,
      equals(<String>[
        'w-[10rem]',
        'bg-[#123456]',
        'shadow-lg',
        'md:hover:bg-red-500',
      ]),
    );
  });
}
