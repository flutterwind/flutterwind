# Typography Utilities Documentation

## Overview

The `TypographyClass` in FlutterWind provides comprehensive typography styling capabilities, allowing you to control text appearance, decoration, transformation, indentation, list styling, and numeric variants.

## Available Typography Utilities

### Text Alignment

Control text alignment with the following utilities:

```dart
'text-left'      // Align text to the left
'text-center'    // Center text
'text-right'     // Align text to the right
'text-justify'   // Justify text
```

### Text Size

Set text size using predefined sizes or custom values:

```dart
'text-xs'        // Extra small text (12px)
'text-sm'        // Small text (14px)
'text-base'      // Base text size (16px)
'text-lg'        // Large text (18px)
'text-xl'        // Extra large text (20px)
'text-2xl'       // 2x large text (24px)
'text-3xl'       // 3x large text (30px)
'text-4xl'       // 4x large text (36px)
'text-5xl'       // 5x large text (48px)
'text-6xl'       // 6x large text (60px)
'text-[16]'      // Custom text size (16px)
```

### Font Weight

Control font weight with these utilities:

```dart
'font-thin'      // Font weight 100
'font-light'     // Font weight 300
'font-normal'    // Font weight 400
'font-medium'    // Font weight 500
'font-bold'      // Font weight 700
'font-black'     // Font weight 900
```

### Text Decoration

Apply text decorations with these utilities:

```dart
'decoration-underline'     // Add underline to text
'decoration-overline'      // Add overline to text
'decoration-line-through'  // Add strikethrough to text
'decoration-none'          // Remove text decorations
```

### Text Transform

Transform text case with these utilities:

```dart
'uppercase'      // Convert text to uppercase
'lowercase'      // Convert text to lowercase
'capitalize'     // Capitalize first letter of each word
'normal-case'    // Use normal case (no transformation)
```

### Text Indentation

Indent text with these utilities:

```dart
'indent-1'       // Indent text by 4px
'indent-2'       // Indent text by 8px
'indent-4'       // Indent text by 16px
'indent-8'       // Indent text by 32px
'indent-[20]'    // Custom indent of 20px
```

### List Style Types

Apply list style markers with these utilities:

```dart
'list-none'      // No list marker
'list-disc'      // Bullet point marker (•)
'list-circle'    // Circle marker (○)
'list-square'    // Square marker (■)
'list-decimal'   // Decimal numbers (1., 2., etc.)
'list-roman'     // Roman numerals (I., II., etc.)
'list-alpha'     // Alphabetic markers (a., b., etc.)
```

### Font Variant Numeric

Control the appearance of numbers with these utilities:

```dart
'numeric-normal'           // Default numeric styling
'numeric-ordinal'          // Ordinal numbers (1st, 2nd, etc.)
'numeric-slashed-zero'     // Slashed zeros (0̸)
'numeric-lining-nums'      // Lining figures (same height)
'numeric-oldstyle-nums'    // Old-style figures (varying heights)
'numeric-proportional-nums' // Proportional width figures
'numeric-tabular-nums'     // Monospaced width figures
'numeric-diagonal-fractions' // Diagonal fractions (½)
'numeric-stacked-fractions'  // Stacked fractions (⁴⁄₅)
```

## Usage in Code

Typography utilities are applied through the FlutterWind styling system:

```dart
// Create a style object
FlutterWindStyle style = FlutterWindStyle();

// Apply typography styles
TypographyClass.apply('text-xl', style);
TypographyClass.apply('font-bold', style);
TypographyClass.apply('decoration-underline', style);
TypographyClass.apply('uppercase', style);
TypographyClass.apply('indent-4', style);
TypographyClass.apply('list-disc', style);
TypographyClass.apply('numeric-tabular-nums', style);

// Build a widget with the typography styles
Widget styledWidget = style.build(Text('Styled Text'));
```

In practice, these typography utilities are typically applied through the FlutterWind styling system rather than directly calling the `TypographyClass`.

## Implementation Details

The `TypographyClass` extends the `FlutterWindStyle` class with typography-related properties and updates the parser to recognize these new utility classes. Text transformations are applied at build time, modifying the text content of Text widgets.

List style utilities are implemented using a Row widget with a marker and the original content, as Flutter doesn't have direct list style support.

Font variant numeric utilities use Flutter's `FontFeature` class to apply OpenType font features for numeric variants.