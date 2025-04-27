# FlutterWind Documentation

## Introduction

FlutterWind is a utility-first styling framework for Flutter, inspired by Tailwind CSS. It provides a comprehensive set of pre-built utilities that can be composed to build any design, directly in your markup.

## Documentation Index

### Core Concepts

- [Configuration System](./configuration.md) - Learn how to customize FlutterWind to match your design system
- [Responsive Design](./responsive_design.md) - Create layouts that adapt to different screen sizes

### Layout

- [Layout Utilities](./layout_utils.md) - Flexbox and Grid system documentation

### Styling

- [Typography](./typography_utils.md) - Text styling, decoration, and transformation
- [Transform Utilities](./transform_utils.md) - Scale, rotate, translate, and skew transformations
- [Filter Effects](./filter_effects.md) - Blur, brightness/contrast, and drop shadow effects

## Getting Started

To use FlutterWind in your Flutter project, add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutterwind_core: ^latest_version
```

Then, import the package in your Dart code:

```dart
import 'package:flutterwind_core/flutterwind_core.dart';
```

## Basic Usage

FlutterWind utilities are applied through the `className` extension method:

```dart
// Apply multiple utilities to a widget
Container(
  child: Text('Hello FlutterWind'),
).className('bg-blue-500 p-4 rounded-lg text-white font-bold')
```

## Configuration

Create a `flutterwind.yaml` file in your project root to customize the framework:

```yaml
# Example configuration
colors:
  primary:
    500: '#3B82F6'
  secondary:
    500: '#10B981'

spacing:
  0: 0
  1: 4
  2: 8
  4: 16
  8: 32

screens:
  sm: 640
  md: 768
  lg: 1024
  xl: 1280
```

See the [Configuration System](./configuration.md) documentation for more details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.