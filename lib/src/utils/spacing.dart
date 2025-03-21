class SpacingUtils {
  static final Map<String, double> _spacingMap = {
    '0': 0.0,
    '1': 4.0,
    '2': 8.0,
    '3': 12.0,
    '4': 16.0,
    '5': 20.0,
    '6': 24.0,
    '7': 28.0,
    '8': 32.0,
    '9': 36.0,
    '10': 40.0,
    '11': 44.0,
    '12': 48.0,
    '14': 56.0,
    '16': 64.0,
    '20': 80.0,
    '24': 96.0,
    '28': 112.0,
    '32': 128.0,
    '36': 144.0,
    '40': 160.0,
    '44': 176.0,
    '48': 192.0,
    '52': 208.0,
    '56': 224.0,
    '60': 240.0,
    '64': 256.0,
    '72': 288.0,
    '80': 320.0,
    '96': 384.0,
  };

  static double parseSpacing(String className) {
    final parts = className.split('-');
    if (parts.length < 2) return 0.0;

    final value = parts.last;
    return _spacingMap[value] ?? 0.0;
  }

  static double parseFractionalSpacing(String value) {
    if (value.contains('/')) {
      final parts = value.split('/');
      if (parts.length == 2) {
        final numerator = double.tryParse(parts[0]) ?? 1;
        final denominator = double.tryParse(parts[1]) ?? 1;
        return (numerator / denominator) * 4.0;
      }
    }
    return double.tryParse(value)?.toDouble() ?? 0.0;
  }
}
