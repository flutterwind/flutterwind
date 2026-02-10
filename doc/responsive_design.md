# Responsive Design Documentation

## Overview

FlutterWind provides a powerful responsive design system that allows you to create layouts that adapt to different screen sizes. Similar to Tailwind CSS, FlutterWind uses breakpoints and responsive prefixes to apply different styles based on the viewport width.

## Breakpoints

FlutterWind comes with default breakpoints that match Tailwind CSS:

```yaml
screens:
  sm: 640   # Small screens (640px and up)
  md: 768   # Medium screens (768px and up)
  lg: 1024  # Large screens (1024px and up)
  xl: 1280  # Extra large screens (1280px and up)
  2xl: 1536 # 2x extra large screens (1536px and up)
```

These breakpoints can be customized in your `flutterwind.yaml` configuration file.

## Responsive Prefixes

You can use responsive prefixes to apply styles at specific breakpoints. The syntax is `{breakpoint}:{utility}`:

```dart
// Apply different text sizes at different breakpoints
Text('Responsive Text').className('text-sm md:text-base lg:text-lg xl:text-xl')
```

In this example:
- `text-sm` applies on all screen sizes
- `md:text-base` applies on medium screens (768px) and up
- `lg:text-lg` applies on large screens (1024px) and up
- `xl:text-xl` applies on extra large screens (1280px) and up

## Available Responsive Utilities

Almost all FlutterWind utilities can be made responsive by adding a breakpoint prefix. Here are some examples:

### Responsive Layout

```dart
// Stack items vertically on small screens, horizontally on medium and up
Row(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
).className('flex-col md:flex-row')

// Change justification based on screen size
Row(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
).className('justify-center md:justify-between lg:justify-around')
```

### Responsive Sizing

```dart
// Change width based on screen size
Container().className('w-full md:w-1/2 lg:w-1/3')

// Change height based on screen size
Container().className('h-20 md:h-32 lg:h-40')
```

### Responsive Typography

```dart
// Change text alignment based on screen size
Text('Responsive Text').className('text-center md:text-left lg:text-right')

// Change font weight based on screen size
Text('Responsive Text').className('font-normal md:font-medium lg:font-bold')
```

### Responsive Spacing

```dart
// Change padding based on screen size
Container().className('p-2 md:p-4 lg:p-8')

// Change margin based on screen size
Container().className('m-2 md:m-4 lg:m-8')
```

### Responsive Grid

```dart
// Change grid columns based on screen size
[
  Container(color: Colors.red),
  Container(color: Colors.blue),
  Container(color: Colors.green),
  Container(color: Colors.yellow),
].className('grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4')
```

## Mobile-First Approach

FlutterWind follows a mobile-first approach, where styles without a breakpoint prefix apply to all screen sizes, and breakpoint prefixes apply to that screen size and up.

This means you should start by designing for mobile screens and then add responsive prefixes to adapt the layout for larger screens.

## Responsive Variants

You can also create responsive variants for state-based utilities like hover and focus:

```dart
// Apply hover effect only on large screens and up
Container().className('bg-blue-500 lg:hover:bg-blue-700')
```

## Detecting Current Breakpoint

You can detect the current breakpoint in your code using the `FlutterWindBreakpoints` class:

```dart
import 'package:flutterwind_core/src/utils/flutterwind_breakpoints.dart';

Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final currentBreakpoint = FlutterWindBreakpoints.getCurrentBreakpoint(screenWidth);
  
  // Use currentBreakpoint to make decisions
  if (currentBreakpoint == 'lg') {
    // Apply large screen specific logic
  }
  
  return Container();
}
```

## Implementation Details

The responsive design system is implemented in the `FlutterWindParser` class, which parses utility classes and applies them based on the current screen width.

When a widget with responsive utilities is built, FlutterWind checks the current screen width against the defined breakpoints and applies the appropriate styles.

The `FlutterWindBreakpoints` class provides utilities for working with breakpoints, including methods to get the current breakpoint and check if a specific breakpoint is active.

## Best Practices

1. **Start with mobile designs**: Define base styles without breakpoint prefixes, then add responsive prefixes for larger screens.

2. **Use meaningful breakpoints**: Customize breakpoints to match your design requirements rather than using arbitrary values.

3. **Test on real devices**: Responsive designs should be tested on actual devices to ensure they work as expected.

4. **Avoid breakpoint-specific logic**: Try to use responsive utilities rather than conditional logic based on breakpoints.

5. **Group responsive utilities**: Keep related responsive utilities together for better readability:

   ```dart
   // Good: Grouped by property
   'text-sm md:text-base lg:text-lg p-2 md:p-4 lg:p-6'
   
   // Avoid: Mixed responsive utilities
   'text-sm p-2 md:text-base md:p-4 lg:text-lg lg:p-6'
   ```

6. **Use the smallest set of utilities**: Only add responsive variants when necessary to keep your code clean and maintainable.