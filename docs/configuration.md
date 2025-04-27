# FlutterWind Configuration System

## Overview

The FlutterWind configuration system allows you to customize the default values and behavior of the framework to match your design system. Similar to Tailwind CSS, FlutterWind provides a way to define your theme, including colors, spacing, typography, and more.

## Configuration Options

FlutterWind supports the following configuration categories:

### Colors

Define your color palette with support for different shades:

```yaml
colors:
  primary:
    500: '#3B82F6'  # Base color
    600: '#2563EB'  # Darker shade
    400: '#60A5FA'  # Lighter shade
  secondary: '#10B981'  # Single color value
  neutral:
    50: '#F9FAFB'
    100: '#F3F4F6'
    900: '#111827'
```

### Spacing

Define your spacing scale for margins, padding, and gaps:

```yaml
spacing:
  0: 0
  1: 4
  2: 8
  3: 12
  4: 16
  8: 32
  16: 64
```

### Breakpoints

Define responsive breakpoints for different screen sizes:

```yaml
screens:
  sm: 640
  md: 768
  lg: 1024
  xl: 1280
  '2xl': 1536
```

### Typography

Configure font sizes, weights, and families:

```yaml
fontSize:
  xs: 12
  sm: 14
  base: 16
  lg: 18
  xl: 20
  '2xl': 24
  '3xl': 30

fontWeight:
  thin: 100
  light: 300
  normal: 400
  medium: 500
  bold: 700
  black: 900

fontFamily:
  sans: ['Roboto', 'Arial', 'sans-serif']
  serif: ['Merriweather', 'Georgia', 'serif']
  mono: ['Roboto Mono', 'Courier New', 'monospace']
```

### Border Radius

Define border radius values:

```yaml
borderRadius:
  none: 0
  sm: 2
  md: 4
  lg: 8
  xl: 12
  full: 9999
```

### Box Shadows

Define shadow presets:

```yaml
boxShadow:
  sm: [0, 1, 2, 0, 'rgba(0,0,0,0.05)']
  md: [0, 4, 6, -1, 'rgba(0,0,0,0.1)']
  lg: [0, 10, 15, -3, 'rgba(0,0,0,0.1)']
```

### Filter Effects

Configure blur, brightness, contrast, and drop shadow values:

```yaml
blur:
  none: 0
  sm: 4
  md: 8
  lg: 12
  xl: 16

brightness:
  0: 0.0
  50: 0.5
  100: 1.0
  150: 1.5

contrast:
  0: 0.0
  50: 0.5
  100: 1.0
  150: 1.5

dropShadow:
  sm: [0, 1, 1, 'rgba(0,0,0,0.05)']
  md: [0, 4, 3, 'rgba(0,0,0,0.07)']
  lg: [0, 10, 8, 'rgba(0,0,0,0.1)']
```

## Configuration File

FlutterWind looks for a `flutterwind.yaml` file in your project root directory. This file should contain your custom configuration:

```yaml
# flutterwind.yaml
colors:
  primary:
    500: '#3B82F6'
    600: '#2563EB'
    400: '#60A5FA'
  accent: '#F59E0B'

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

fontSize:
  base: 16
  lg: 18
  xl: 20
```

## Loading Configuration

FlutterWind automatically loads the configuration when your app starts. You can also manually load or update the configuration:

```dart
import 'package:flutterwind_core/flutterwind_core.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

Future<void> loadCustomConfig() async {
  // Load from asset
  final yamlString = await rootBundle.loadString('assets/custom_config.yaml');
  final yamlMap = loadYaml(yamlString);
  
  // Update configuration
  TailwindConfig.updateFromYaml(yamlMap);
}
```

## Accessing Configuration Values

You can access configuration values programmatically:

```dart
// Get primary color with shade 500
final primaryColor = TailwindConfig.colors['primary']?[500];

// Get spacing value
final spacing4 = TailwindConfig.spacing['4'];

// Get font size
final baseFontSize = TailwindConfig.fontSize['base'];
```

## Default Values

FlutterWind comes with sensible defaults based on Tailwind CSS. If you don't provide a custom configuration, these defaults will be used. When you provide a partial configuration, it will be merged with the defaults, overriding only the values you specify.

## Implementation Details

The configuration system is implemented in the `TailwindConfig` class, which provides static properties for different configuration categories and methods for parsing and updating configuration values from YAML.

The `updateFromYaml` method merges your custom configuration with the default values, allowing for partial configuration updates while maintaining backward compatibility.

Color values are parsed from hex strings to Flutter's `Color` objects, and other values are converted to appropriate types (double, int, etc.) as needed.