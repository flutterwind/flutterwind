class ComponentPresetRegistry {
  static final Map<String, String> _presets = <String, String>{
    'btn': 'px-4 py-2 rounded-md font-medium',
    'btn-primary': 'bg-primary text-primary-foreground',
    'btn-secondary': 'bg-secondary text-secondary-foreground',
    'btn-outline': 'border bg-surface text-surface-foreground',
    'btn-sm': 'px-2 py-1 text-sm',
    'btn-lg': 'px-6 py-3 text-lg',
    'card': 'rounded-lg bg-surface text-surface-foreground p-4 shadow',
    'card-header': 'mb-2 text-lg font-semibold',
    'card-body': 'text-sm text-muted',
    'input-filled': 'input-md bg-surface text-surface-foreground',
  };

  static String? getPreset(String token) => _presets[token];

  static List<String> presetKeys() => _presets.keys.toList(growable: false);

  static void registerPreset(String token, String expansion) {
    final key = token.trim();
    if (key.isEmpty) return;
    _presets[key] = expansion.trim();
  }

  static void unregisterPreset(String token) {
    _presets.remove(token.trim());
  }
}
