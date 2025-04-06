import 'package:flutterwind_core/src/utils/parser.dart';
import 'package:flutterwind_core/src/utils/spacing.dart';

// class GridClass {
//   static void apply(String cls, FlutterWindStyle style) {
//     // Track grid-specific properties
//     int childIndex = 0;

//     if (cls == 'grid') {
//       style.isGrid = true;
//     } else if (cls.startsWith('grid-cols-')) {
//       style.gridColumns = int.parse(cls.split('-').last);
//     } else if (cls.startsWith('gap-')) {
//       style.gridGap = SpacingUtils.parseSpacing(cls);
//     } else if (cls.startsWith('col-span-')) {
//       style.colSpans[childIndex] = int.parse(cls.split('-').last);
//       childIndex++;
//     }
//   }
// }
