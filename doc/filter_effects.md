# FlutterWind Filter Effects

This document describes the filter and effects functionality in FlutterWind, which provides Tailwind CSS-like filter classes for Flutter applications.

## Available Filters

FlutterWind now supports the following filter effects:

1. **Blur Effects**
2. **Brightness/Contrast Adjustments**
3. **Drop Shadows**
4. **Backdrop Filters**
5. **Transform Utilities**

## Usage

All filter effects can be applied using the `.className()` extension method on any Flutter widget.

### Blur Effects

Apply blur effects to any widget using the `blur-{amount}` class:

```dart
Container(
  width: 200,
  height: 100,
  color: Colors.blue,
).className('blur-md')
```

Available blur values:
- `blur-none`: No blur (0px)
- `blur-sm`: Light blur (4px)
- `blur-md`: Medium blur (8px)
- `blur-lg`: Large blur (12px)
- `blur-xl`: Extra large blur (16px)
- `blur-2xl`: 2x extra large blur (24px)
- `blur-3xl`: 3x extra large blur (32px)

You can also use arbitrary values with the syntax: `blur-[10px]`

### Brightness Adjustments

Adjust the brightness of any widget using the `brightness-{amount}` class:

```dart
Image.network(
  'https://example.com/image.jpg',
).className('brightness-150')
```

Available brightness values:
- `brightness-0`: 0% brightness
- `brightness-50`: 50% brightness
- `brightness-75`: 75% brightness
- `brightness-90`: 90% brightness
- `brightness-95`: 95% brightness
- `brightness-100`: Normal brightness (100%)
- `brightness-105`: 105% brightness
- `brightness-110`: 110% brightness
- `brightness-125`: 125% brightness
- `brightness-150`: 150% brightness
- `brightness-200`: 200% brightness

You can also use arbitrary values with the syntax: `brightness-[125]`

### Contrast Adjustments

Adjust the contrast of any widget using the `contrast-{amount}` class:

```dart
Image.network(
  'https://example.com/image.jpg',
).className('contrast-200')
```

Available contrast values:
- `contrast-0`: 0% contrast
- `contrast-50`: 50% contrast
- `contrast-75`: 75% contrast
- `contrast-90`: 90% contrast
- `contrast-95`: 95% contrast
- `contrast-100`: Normal contrast (100%)
- `contrast-105`: 105% contrast
- `contrast-110`: 110% contrast
- `contrast-125`: 125% contrast
- `contrast-150`: 150% contrast
- `contrast-200`: 200% contrast

You can also use arbitrary values with the syntax: `contrast-[125]`

### Drop Shadows

Apply drop shadows to any widget using the `drop-shadow-{size}` class:

```dart
Container(
  width: 200,
  height: 100,
  color: Colors.white,
).className('drop-shadow-lg')
```

Available drop shadow sizes:
- `drop-shadow-sm`: Small shadow
- `drop-shadow-md`: Medium shadow
- `drop-shadow-lg`: Large shadow
- `drop-shadow-xl`: Extra large shadow
- `drop-shadow-2xl`: 2x extra large shadow

You can also use arbitrary values with the syntax: `drop-shadow-[0_4px_6px_rgba(0,0,0,0.1)]`

### Backdrop Filters

Apply backdrop filters (effects that apply to the content behind an element) using the `backdrop-blur-{amount}` class:

```dart
Container(
  color: Colors.white.withOpacity(0.5),
).className('backdrop-blur-md')
```

Backdrop blur uses the same size values as regular blur.

## Configuration

You can customize the filter values in your Tailwind configuration file:

```yaml
blur:
  sm: 4.0
  md: 8.0
  lg: 12.0
  xl: 16.0
  2xl: 24.0
  3xl: 32.0

brightness:
  0: 0.0
  50: 0.5
  # ... other values

contrast:
  0: 0.0
  50: 0.5
  # ... other values

dropShadow:
  sm:
    color: '#1A000000'
    blurRadius: 4.0
    offsetX: 0
    offsetY: 1
  # ... other values
```

## Transform Utilities

FlutterWind provides Tailwind CSS-like transform utilities for Flutter applications. These utilities allow you to apply various transformations to your widgets.

### Scale

Scale widgets using the `scale-{amount}` class:

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
).className('scale-150')
```

Available scale values:
- `scale-0`: Scale to 0 (invisible)
- `scale-50`: Scale to 50%
- `scale-75`: Scale to 75%
- `scale-90`: Scale to 90%
- `scale-95`: Scale to 95%
- `scale-100`: Normal scale (100%)
- `scale-105`: Scale to 105%
- `scale-110`: Scale to 110%
- `scale-125`: Scale to 125%
- `scale-150`: Scale to 150%
- `scale-200`: Scale to 200%

You can also scale X and Y axes independently:
- `scale-x-{amount}`: Scale horizontally
- `scale-y-{amount}`: Scale vertically

Arbitrary values can be used with the syntax: `scale-[125]`, `scale-x-[125]`, or `scale-y-[125]`

### Rotate

Rotate widgets using the `rotate-{amount}` class:

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
).className('rotate-45')
```

Available rotation values:
- `rotate-0`: No rotation (0 degrees)
- `rotate-1`: Rotate 1 degree
- `rotate-2`: Rotate 2 degrees
- `rotate-3`: Rotate 3 degrees
- `rotate-6`: Rotate 6 degrees
- `rotate-12`: Rotate 12 degrees
- `rotate-45`: Rotate 45 degrees
- `rotate-90`: Rotate 90 degrees
- `rotate-180`: Rotate 180 degrees

Negative rotations are also available with the `-` prefix:
- `-rotate-1`: Rotate -1 degree
- `-rotate-2`: Rotate -2 degrees
- `-rotate-3`: Rotate -3 degrees
- `-rotate-6`: Rotate -6 degrees
- `-rotate-12`: Rotate -12 degrees
- `-rotate-45`: Rotate -45 degrees
- `-rotate-90`: Rotate -90 degrees
- `-rotate-180`: Rotate -180 degrees

Arbitrary values can be used with the syntax: `rotate-[30deg]` or `-rotate-[30deg]`

### Translate

Translate (move) widgets using the `translate-x-{amount}` and `translate-y-{amount}` classes:

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
).className('translate-x-4')
```

Available translation values:
- `translate-x-0`: No horizontal translation
- `translate-x-1`: Translate 4px horizontally
- `translate-x-2`: Translate 8px horizontally
- `translate-x-4`: Translate 16px horizontally
- `translate-x-8`: Translate 32px horizontally
- `translate-x-12`: Translate 48px horizontally
- `translate-x-16`: Translate 64px horizontally

Similar values are available for vertical translation with `translate-y-{amount}`.

Negative translations are also available with the `-` prefix:
- `-translate-x-1`: Translate -4px horizontally
- `-translate-x-2`: Translate -8px horizontally
- etc.

Arbitrary values can be used with the syntax: `translate-x-[10px]` or `translate-y-[25%]`

### Skew

Skew widgets using the `skew-x-{amount}` and `skew-y-{amount}` classes:

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
).className('skew-x-12')
```

Available skew values:
- `skew-x-0`: No horizontal skew
- `skew-x-1`: Skew 1 degree horizontally
- `skew-x-2`: Skew 2 degrees horizontally
- `skew-x-3`: Skew 3 degrees horizontally
- `skew-x-6`: Skew 6 degrees horizontally
- `skew-x-12`: Skew 12 degrees horizontally

Similar values are available for vertical skew with `skew-y-{amount}`.

Negative skews are also available with the `-` prefix:
- `-skew-x-1`: Skew -1 degree horizontally
- `-skew-x-2`: Skew -2 degrees horizontally
- etc.

Arbitrary values can be used with the syntax: `skew-x-[15deg]` or `skew-y-[15deg]`

### Transform Origin

Set the origin point for transformations using the `origin-{position}` class:

```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
).className('rotate-45 origin-top-left')
```

Available origin values:
- `origin-center`: Center of the element (default)
- `origin-top`: Top center of the element
- `origin-top-right`: Top right corner of the element
- `origin-right`: Right center of the element
- `origin-bottom-right`: Bottom right corner of the element
- `origin-bottom`: Bottom center of the element
- `origin-bottom-left`: Bottom left corner of the element
- `origin-left`: Left center of the element
- `origin-top-left`: Top left corner of the element

Arbitrary values can be used with the syntax: `origin-[25%_75%]`

## Configuration

You can customize the transform values in your Tailwind configuration file:

```yaml
scale:
  0: 0.0
  50: 0.5
  75: 0.75
  90: 0.9
  95: 0.95
  100: 1.0
  105: 1.05
  110: 1.1
  125: 1.25
  150: 1.5
  200: 2.0

rotate:
  0: 0.0
  1: 1.0
  2: 2.0
  3: 3.0
  6: 6.0
  12: 12.0
  45: 45.0
  90: 90.0
  180: 180.0

translate:
  0: 0.0
  1: 4.0
  2: 8.0
  4: 16.0
  8: 32.0
  12: 48.0
  16: 64.0

skew:
  0: 0.0
  1: 1.0
  2: 2.0
  3: 3.0
  6: 6.0
  12: 12.0
```

## Example

See the complete example in `example/filter_effects_example.dart`.