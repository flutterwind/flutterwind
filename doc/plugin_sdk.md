# FlutterWind Plugin SDK

This guide shows how to build and use plugins for FlutterWind.

## What a plugin can do

With the current SDK, plugins can:

- register custom utility handlers
- add or override component presets
- control precedence using handler `order`

## Public APIs you will use

Import:

```dart
import 'package:flutterwind_core/flutterwind.dart';
```

Core APIs:

- `registerFlutterWindUtilityHandler(FlutterWindClassHandler handler)`
- `ComponentPresetRegistry.registerPreset(String token, String expansion)`
- `ComponentPresetRegistry.unregisterPreset(String token)`

## 1) Create a utility plugin

Example: add a custom utility `debug-outline` that applies a red outline.

```dart
import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class DebugOutlinePlugin {
  static void install() {
    registerFlutterWindUtilityHandler(
      FlutterWindClassHandler(
        name: 'debug_outline_plugin',
        order: 999,
        apply: (cls, style) {
          final flutterStyle = style as FlutterWindStyle;
          if (cls == 'debug-outline') {
            flutterStyle.boxShadows = <BoxShadow>[
              const BoxShadow(
                color: Color(0xFFFF0000),
                spreadRadius: 0,
                blurRadius: 0,
              ),
            ];
          }
        },
      ),
    );
  }
}
```

Then install once during app startup:

```dart
void main() {
  DebugOutlinePlugin.install();
  runApp(const MyApp());
}
```

Use it like any other class:

```dart
Container().className('p-4 debug-outline');
```

## 2) Create a preset plugin

Example: register reusable preset tokens for teams/design systems.

```dart
import 'package:flutterwind_core/flutterwind.dart';
import 'package:flutterwind_core/src/presets/component_presets.dart';

class TeamPresetPlugin {
  static void install() {
    ComponentPresetRegistry.registerPreset(
      'btn-brand',
      'btn bg-primary text-primary-foreground rounded-lg px-6 py-3',
    );

    ComponentPresetRegistry.registerPreset(
      'card-elevated',
      'card shadow-lg border p-6',
    );
  }
}
```

Use presets:

```dart
ElevatedButton(onPressed: () {}, child: const Text('Save'))
    .className('btn-brand');
```

## 3) Precedence and override rules

- Utilities are applied in class-string order (last wins for conflicting fields).
- Handler `order` controls when your plugin runs relative to core handlers.
- If your plugin should override most core behavior, use a larger `order`.
- If your plugin should set defaults only, use a smaller `order`.

## 4) Recommended plugin structure

For external packages, keep this shape:

- `lib/my_flutterwind_plugin.dart` (exports + installer)
- `lib/src/<feature>_plugin.dart` (utility handlers)
- `lib/src/<preset>_plugin.dart` (preset registration)

Example entry file:

```dart
library my_flutterwind_plugin;

export 'src/install.dart';
```

## 5) Safety and compatibility notes

- Use unique handler names (for example, package-prefixed names).
- Avoid touching `lib/src/**` internals from FlutterWind directly; rely on public exports.
- Follow `doc/api_stability_and_semver.md` for stable API expectations.
- Keep plugin installs idempotent in your package (guard against duplicate install calls).

## 6) Debugging plugin behavior

You can pass a diagnostics collector to `className(...)` to inspect unsupported utilities/variants:

```dart
final collector = FlutterWindDiagnosticsCollector();
Text('Hello').className(
  'my-unknown-utility',
  diagnosticsCollector: collector,
);
```

Open DeveloperTools diagnostics tab to inspect runtime parser diagnostics in-app.
