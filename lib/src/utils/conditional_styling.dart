/// Utility function to apply multiple conditional classes.
String cn(Object? first, [Object? second = const []]) {
  final List<Object?> allArgs =
      [first, second].expand((e) => e is List ? e : [e]).toList();

  return allArgs
      .map((entry) {
        if (entry is String) return entry;
        if (entry is Map<String, bool>) {
          return entry.entries
              .where((e) => e.value)
              .map((e) => e.key)
              .join(' ');
        }
        return '';
      })
      .where((e) => e.isNotEmpty)
      .join(' ');
}
