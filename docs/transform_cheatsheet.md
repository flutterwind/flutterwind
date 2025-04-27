# FlutterWind Transform Utilities Cheat Sheet

This cheat sheet provides a quick reference for all transform utilities available in FlutterWind.

## Scale Transforms

| Class | Example | Description |
|-------|---------|-------------|
| `scale-{value}` | `scale-150` | Scale both X and Y axes to 150% |
| `scale-x-{value}` | `scale-x-75` | Scale X axis to 75% |
| `scale-y-{value}` | `scale-y-125` | Scale Y axis to 125% |
| `scale-[value]` | `scale-[1.35]` | Scale with arbitrary value |

**Available Scale Values**: `0`, `50`, `75`, `90`, `95`, `100`, `105`, `110`, `125`, `150`, `200`

## Rotate Transforms

| Class | Example | Description |
|-------|---------|-------------|
| `rotate-{value}` | `rotate-45` | Rotate 45° clockwise |
| `rotate-{negative}` | `rotate-[-45]` | Rotate 45° counterclockwise |
| `rotate-[value]` | `rotate-[33deg]` | Rotate with arbitrary value |

**Available Rotate Values**: 
- Positive: `0`, `1`, `2`, `3`, `6`, `12`, `45`, `90`, `180`
- Negative: `-1`, `-2`, `-3`, `-6`, `-12`, `-45`, `-90`, `-180`

## Translate Transforms

| Class | Example | Description |
|-------|---------|-------------|
| `translate-x-{value}` | `translate-x-4` | Move 4px horizontally |
| `translate-y-{value}` | `translate-y-6` | Move 6px vertically |
| `translate-x-{fraction}` | `translate-x-1/2` | Move 50% of width horizontally |
| `translate-y-{fraction}` | `translate-y-1/4` | Move 25% of height vertically |
| `translate-x-[value]` | `translate-x-[25px]` | Move with arbitrary value horizontally |
| `translate-y-[value]` | `translate-y-[-15px]` | Move with arbitrary value vertically |

## Skew Transforms

| Class | Example | Description |
|-------|---------|-------------|
| `skew-x-{value}` | `skew-x-12` | Skew 12° horizontally |
| `skew-y-{value}` | `skew-y-6` | Skew 6° vertically |
| `skew-x-[value]` | `skew-x-[17deg]` | Skew with arbitrary value horizontally |
| `skew-y-[value]` | `skew-y-[-8deg]` | Skew with arbitrary value vertically |

## Transform Origin

| Class | Example | Description |
|-------|---------|-------------|
| `origin-{position}` | `origin-top-left` | Set transform origin to top left |
| `origin-[value]` | `origin-[10px_20px]` | Set arbitrary transform origin |

**Available Origin Values**: `center` (default), `top`, `top-right`, `right`, `bottom-right`, `bottom`, `bottom-left`, `left`, `top-left`

## Combining Transforms

Transforms can be combined by adding multiple classes:

```dart
// Scale, rotate, and translate
FW(
  'scale-125 rotate-45 translate-x-4',
  child: myWidget,
)

// Skew with custom origin
FW(
  'skew-x-12 origin-bottom-left',
  child: myWidget,
)
```