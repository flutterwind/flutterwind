# Tailwind v4 Runtime Parity

## Semantic contract

FlutterWind runtime parser follows these rules for Tailwind-style class strings:

- **Last utility wins**: later classes override earlier ones for the same property.
- **Variant chain AND semantics**: every variant in a chain must match.
  - Example: `md:hover:bg-red-500` applies only when the screen is at least `md` and the widget is hovered.
- **State variants supported at runtime**: `hover:`, `focus:`, `active:`.
- **Static variants supported at runtime**: responsive screen keys from `TailwindConfig.screens`, `dark:`, and `light:`.
- **Unsupported variants/utilities are ignored** and emit a debug-only warning.

## Class parsing model

- Class strings are tokenized with bracket-aware parsing, so arbitrary values stay intact.
- Variant chains are parsed as `variant1:variant2:...:utility`.
- Responsive checks use configured breakpoints from `TailwindConfig`.

## Parity matrix

| Category | Status | Notes |
| --- | --- | --- |
| Utility precedence | supported | Tailwind-style last-write-wins behavior |
| Responsive variants (`sm`..`2xl`) | supported | Uses `TailwindConfig.screens` |
| Dark mode variant (`dark:`) | supported | Based on `Theme.of(context).brightness` |
| Light mode variant (`light:`) | supported | Inverse of dark mode |
| State variants (`hover/focus/active`) | supported | Runtime wrapper applies conditional utilities |
| Chained variants (`md:hover:*`) | supported | All conditions must match |
| Arbitrary spacing/sizing values | partial | Supports forms like `w-[10rem]`, `h-[120px]`, spacing bracket values |
| Arbitrary color values | partial | Supports hex values like `bg-[#123456]` |
| CSS-only Tailwind v4 features | not_supported | Features without Flutter runtime equivalents are ignored |

## Known constraints

- Some Tailwind v4 features are CSS-native and cannot map 1:1 to Flutter rendering.
- Background image-specific class semantics require an explicit image source API in FlutterWind.
- Utility support breadth is expanding; use this matrix to track current behavior.
