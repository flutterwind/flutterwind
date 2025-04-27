# Layout Utilities Documentation

## Overview

The layout utilities in FlutterWind provide a powerful way to create responsive layouts using Flexbox and Grid systems, similar to Tailwind CSS. These utilities allow you to build complex layouts with minimal code.

## Flexbox Utilities

Flexbox is a one-dimensional layout method for arranging items in rows or columns. FlutterWind provides comprehensive flexbox utilities to control container and item behavior.

### Flex Direction

Control the direction of flex items with these utilities:

```dart
'flex'          // Default flex row layout
'flex-row'      // Arrange items horizontally (left to right)
'flex-col'      // Arrange items vertically (top to bottom)
'flex-row-reverse'  // Arrange items horizontally (right to left)
'flex-col-reverse'  // Arrange items vertically (bottom to top)
```

### Flex Wrap

Control whether flex items wrap onto multiple lines:

```dart
'flex-wrap'     // Allow items to wrap onto multiple lines
'flex-nowrap'   // Prevent items from wrapping
'flex-wrap-reverse'  // Wrap items in reverse order
```

### Justify Content

Control how items are positioned along the main axis:

```dart
'justify-start'      // Items aligned to the start
'justify-end'        // Items aligned to the end
'justify-center'     // Items centered along the line
'justify-between'    // Items evenly distributed with first item at start, last at end
'justify-around'     // Items evenly distributed with equal space around them
'justify-evenly'     // Items evenly distributed with equal space between them
```

### Align Items

Control how items are positioned along the cross axis:

```dart
'items-start'    // Items aligned to the start of the cross axis
'items-end'      // Items aligned to the end of the cross axis
'items-center'   // Items centered along the cross axis
'items-stretch'  // Items stretched to fill the container along the cross axis
'items-baseline' // Items aligned by their baselines
```

### Align Content

Control how lines are positioned when there's extra space in the cross axis:

```dart
'content-start'    // Lines packed at the start
'content-end'      // Lines packed at the end
'content-center'   // Lines centered in the container
'content-between'  // Lines evenly distributed with first line at start, last at end
'content-around'   // Lines evenly distributed with equal space around them
'content-stretch'  // Lines stretched to fill the container
```

### Align Self

Override the alignment for individual flex items:

```dart
'self-auto'      // Default auto alignment
'self-start'     // Item aligned to the start
'self-end'       // Item aligned to the end
'self-center'    // Item centered
'self-stretch'   // Item stretched to fill the container
'self-baseline'  // Item aligned by its baseline
```

### Flex Grow / Shrink

Control how flex items grow or shrink:

```dart
'flex-grow'      // Allow item to grow to fill available space
'flex-grow-0'    // Prevent item from growing
'flex-shrink'    // Allow item to shrink if necessary
'flex-shrink-0'  // Prevent item from shrinking
```

### Flex Basis

Set the initial main size of a flex item:

```dart
'basis-auto'     // Default size based on content
'basis-0'        // Size of 0
'basis-1/2'      // 50% of the container
'basis-1/3'      // 33.333% of the container
'basis-2/3'      // 66.667% of the container
'basis-1/4'      // 25% of the container
'basis-3/4'      // 75% of the container
'basis-[200px]'  // Custom size of 200px
```

## Grid System

The grid system allows for two-dimensional layouts with rows and columns. FlutterWind provides utilities to create and control grid layouts.

### Grid Template Columns

Define the columns of your grid:

```dart
'grid'           // Enable grid layout
'grid-cols-1'    // One column grid
'grid-cols-2'    // Two column grid
'grid-cols-3'    // Three column grid
'grid-cols-4'    // Four column grid
'grid-cols-5'    // Five column grid
'grid-cols-6'    // Six column grid
'grid-cols-12'   // Twelve column grid
'grid-cols-none' // No defined columns
```

### Grid Column Span

Control how many columns an item spans:

```dart
// Use the colSpan extension method
Container().colSpan(2)  // Span 2 columns
Container().colSpan(3)  // Span 3 columns
Container().colSpan(4)  // Span 4 columns
```

### Grid Template Rows

Define the rows of your grid:

```dart
'grid-rows-1'    // One row grid
'grid-rows-2'    // Two row grid
'grid-rows-3'    // Three row grid
'grid-rows-4'    // Four row grid
'grid-rows-5'    // Five row grid
'grid-rows-6'    // Six row grid
'grid-rows-none' // No defined rows
```

### Grid Gap

Control the gap between grid items:

```dart
'gap-0'          // No gap
'gap-1'          // 4px gap
'gap-2'          // 8px gap
'gap-4'          // 16px gap
'gap-8'          // 32px gap
'gap-[20px]'     // Custom 20px gap
'gap-x-4'        // 16px horizontal gap
'gap-y-4'        // 16px vertical gap
```

### Grid Auto Flow

Control how auto-placed items are inserted in the grid:

```dart
'grid-flow-row'      // Items fill rows
'grid-flow-col'      // Items fill columns
'grid-flow-dense'    // Dense packing algorithm
```

## Usage in Code

Layout utilities are applied through the FlutterWind styling system:

### Flexbox Example

```dart
// Create a row with centered items
Row(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
).className('flex justify-center items-center')

// Create a column with items aligned to the start
Column(
  children: [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
  ],
).className('flex-col items-start')
```

### Grid Example

```dart
// Create a 3-column grid with gap
[
  Container(color: Colors.red, height: 100).colSpan(1),
  Container(color: Colors.blue, height: 100).colSpan(2),
  Container(color: Colors.green, height: 100).colSpan(3),
  Container(color: Colors.yellow, height: 100).colSpan(1),
].className('grid grid-cols-3 gap-4')
```

## Implementation Details

The layout utilities are implemented in the `layout.dart` file, which provides two main components:

1. **FlexBox Layout**: Implemented using Flutter's `Row` and `Column` widgets with various properties to control alignment, justification, and item behavior.

2. **Grid Layout**: Implemented using a custom grid system that arranges children in a grid pattern based on the specified number of columns and rows.

The `GridItemWrapper` class and `colSpan` extension method allow for controlling how many columns a grid item spans, similar to the `col-span-*` utility in Tailwind CSS.

Responsive layouts can be created by combining these utilities with FlutterWind's responsive design system, allowing for different layouts at different screen sizes.