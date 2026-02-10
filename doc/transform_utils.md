# Transform Utilities Documentation

## Overview

The `TransformUtils` class implements Tailwind CSS transform functionality in Flutter, providing a way to apply various transformations to widgets including scale, rotate, translate, skew, and transform origin settings.

## Available Transformations

### Scale

Scaling transforms allow you to resize elements proportionally or along individual axes.

#### Available Scale Classes

| Class | Description | Example |
|-------|-------------|--------|
| `scale-{value}` | Scale both X and Y axes by the same factor | `scale-150` (scales to 150%) |
| `scale-x-{value}` | Scale only the X axis | `scale-x-75` (scales width to 75%) |
| `scale-y-{value}` | Scale only the Y axis | `scale-y-125` (scales height to 125%) |

#### Predefined Scale Values

- `0` (0%)
- `50` (50%)
- `75` (75%)
- `90` (90%)
- `95` (95%)
- `100` (100%, no scaling)
- `105` (105%)
- `110` (110%)
- `125` (125%)
- `150` (150%)
- `200` (200%)

#### Arbitrary Values

You can use arbitrary values with the bracket syntax:

```dart
'scale-[1.35]'  // Scale to 135%
'scale-x-[0.8]'  // Scale X axis to 80%
'scale-y-[2.5]'  // Scale Y axis to 250%
```

### Rotate

Rotation transforms allow you to rotate elements clockwise or counterclockwise.

#### Available Rotate Classes

| Class | Description | Example |
|-------|-------------|--------|
| `rotate-{value}` | Rotate by specified degrees | `rotate-45` (rotates 45° clockwise) |
| `rotate-{negative-value}` | Rotate counterclockwise | `rotate-[-45]` (rotates 45° counterclockwise) |

#### Predefined Rotation Values

Positive (clockwise) values:
- `0`, `1`, `2`, `3`, `6`, `12`, `45`, `90`, `180` degrees

Negative (counterclockwise) values:
- `-1`, `-2`, `-3`, `-6`, `-12`, `-45`, `-90`, `-180` degrees

#### Arbitrary Values

You can use arbitrary values with the bracket syntax:

```dart
'rotate-[33deg]'  // Rotate 33 degrees clockwise
'rotate-[-78deg]'  // Rotate 78 degrees counterclockwise
```

### Translate

Translate transforms allow you to move elements horizontally or vertically.

#### Available Translate Classes

| Class | Description | Example |
|-------|-------------|--------|
| `translate-x-{value}` | Move horizontally | `translate-x-4` (moves right 4 pixels) |
| `translate-y-{value}` | Move vertically | `translate-y-6` (moves down 6 pixels) |

#### Fractional Values

You can use fractional values to move elements by a percentage of their size:

```dart
'translate-x-1/2'  // Move right by 50% of the element's width
'translate-y-1/4'  // Move down by 25% of the element's height
```

#### Arbitrary Values

You can use arbitrary values with the bracket syntax:

```dart
'translate-x-[25px]'  // Move right 25 pixels
'translate-y-[-15px]'  // Move up 15 pixels
```

### Skew

Skew transforms allow you to slant elements along the X or Y axis.

#### Available Skew Classes

| Class | Description | Example |
|-------|-------------|--------|
| `skew-x-{value}` | Skew horizontally | `skew-x-12` (skews 12° horizontally) |
| `skew-y-{value}` | Skew vertically | `skew-y-6` (skews 6° vertically) |

#### Arbitrary Values

You can use arbitrary values with the bracket syntax:

```dart
'skew-x-[17deg]'  // Skew 17 degrees horizontally
'skew-y-[-8deg]'  // Skew -8 degrees vertically
```

### Transform Origin

Transform origin sets the point around which a transformation is applied.

#### Available Origin Classes

| Class | Description | Example |
|-------|-------------|--------|
| `origin-{position}` | Set transform origin | `origin-top-left` (sets origin to top left corner) |

#### Predefined Origin Values

- `center` (default)
- `top`
- `top-right`
- `right`
- `bottom-right`
- `bottom`
- `bottom-left`
- `left`
- `top-left`

#### Arbitrary Values

You can use arbitrary values with the bracket syntax:

```dart
'origin-[10px_20px]'  // Set origin to 10px from left, 20px from top
```

## Combining Transformations

You can combine multiple transform classes to create complex transformations. The transformations are applied in the order they appear in the class list.

```dart
// Scale, rotate, and translate
'scale-125 rotate-45 translate-x-4'

// Skew with custom origin
'skew-x-12 origin-bottom-left'
```

## Implementation Details

The `TransformUtils` class uses Flutter's `Matrix4` to apply transformations. For percentage-based translations, it stores the factors in `translateXFactor` and `translateYFactor` properties of the `FlutterWindStyle` class.

Transform origin is set using Flutter's `Alignment` class, which is applied when the transformation is rendered.

## Usage in Code

Transformations are applied through the `apply` method of the `TransformUtils` class:

```dart
// Create a style object
FlutterWindStyle style = FlutterWindStyle();

// Apply transformations
TransformUtils.apply('scale-150', style);
TransformUtils.apply('rotate-45', style);
TransformUtils.apply('translate-x-4', style);

// Build a widget with the transformations
Widget transformedWidget = style.build(myWidget);
```

In practice, these transformations are typically applied through the FlutterWind styling system rather than directly calling the `TransformUtils` class.