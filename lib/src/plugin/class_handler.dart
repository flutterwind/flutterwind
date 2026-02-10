typedef FlutterWindClassApply = void Function(String cls, dynamic style);

class FlutterWindClassHandler {
  final String name;
  final int order;
  final FlutterWindClassApply apply;

  const FlutterWindClassHandler({
    required this.name,
    required this.apply,
    this.order = 0,
  });
}
