import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

class FlutterwindButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String variant;
  final String size;
  final String? className;

  const FlutterwindButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = 'default',
    this.size = 'default',
    this.className,
  });

  @override
  Widget build(BuildContext context) {
    final variantClasses = switch (variant) {
      'destructive' =>
        'bg-destructive text-destructive-foreground hover:bg-destructive/90 focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40 dark:bg-destructive/60',
      'outline' =>
        'border border-input bg-background shadow-xs hover:bg-accent hover:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50',
      'secondary' =>
        'bg-secondary text-secondary-foreground hover:bg-secondary/80',
      'ghost' =>
        'hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50',
      'link' => 'text-primary underline-offset-4 hover:underline',
      _ => 'bg-primary text-primary-foreground hover:bg-primary/90',
    };

    final sizeClasses = switch (size) {
      'xs' => 'h-6 gap-1 rounded-md px-2 text-xs',
      'sm' => 'h-8 rounded-md gap-1.5 px-3',
      'lg' => 'h-10 rounded-md px-8',
      'icon' => 'size-9',
      'icon-xs' => 'size-6 rounded-md',
      'icon-sm' => 'size-8',
      'icon-lg' => 'size-10',
      _ => 'h-9 px-4 py-2',
    };

    final resolvedClasses = mergeClasses([
      'inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50 shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive',
      variantClasses,
      sizeClasses,
      className,
    ]);

    // Handle child svg sizing: [&_svg:not([class*='size-'])]:size-4
    // We explicitly set default icon size to 16.0 (size-4)
    // If the child has its own size, it should override this or be passed differently via IconTheme

    // Note: 'gap-2' in base classes implies a Row with gap if logic supports it.
    // Flutterwind might not inject gap into user's child Row.
    // We rely on 'gap-2' being applied to the flex container (this button).
    // If we want gap between children we might need to verify if user passes a list or just One child.
    // React's children can be multiple. Flutter's child is one.
    // Assuming standard usage of Row inside button if multiple items.

    // Determining icon size based on 'size' variant if needed?
    // React code:
    // default: has-[>svg]:px-3
    // xs: [&_svg:not([class*='size-'])]:size-3
    // icon-xs: [&_svg:not([class*='size-'])]:size-3

    double iconSize = 16.0; // size-4 by default
    if (size == 'xs' || size == 'icon-xs') {
      iconSize = 12.0; // size-3
    }

    return SizedBox(
      child: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: IconTheme(
          data: IconThemeData(
            size: iconSize, // Apply default icon size logic
            color: null, // Inherit from text color
          ),
          child: child,
        ),
      ),
    ).className(resolvedClasses).withGestures(onTap: onPressed);
  }
}

String mergeClasses(List<String?> classes) {
  return classes
      .whereType<String>()
      .where((c) => c.trim().isNotEmpty)
      .join(' ');
}
