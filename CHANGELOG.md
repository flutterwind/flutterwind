## 0.0.1

* Initial release.

## 0.0.2

* Bug Fixes
* Fixing the issue with the `FlutterWindStyle` method.

## 0.0.3

* Bug Fixes
* Improvement in `FlutterWindStyle` method.
* Added support for transition, and transform presets.
* Added support for animation presets.
* Added support for Hover states for web and desktop.
* Added support for Grid Layout.
* Added support for Aspect Ratio.
* Added support for Positioning.

## 0.0.4
* Bug Fixes
* Added support for `Filter` and `Effects` presets.
* Added support for `Transform` presets.

## 0.0.5
* Enhanced Developer Tools
  * Added proper edge padding (16px) to prevent sticking to screen corners
  * Fixed positioning when expanding/collapsing
  * Implemented proper layout constraints with fixed heights for different tabs
  * Added SingleChildScrollView for content overflow
* Improved Logging System
  * Added print statement capture using debugPrint override
  * Implemented color-coded log entries (blue for print, red for errors, orange for warnings)
  * Added timestamp and log level display
  * Limited log history to 1000 entries
* Platform Information Display
  * Organized content into three sections (Platform Info, Screen Info, Theme Info)
  * Added section headers with better spacing
  * Improved information formatting and readability
  * Implemented scrollable content with 180px height
* General Improvements
  * Added proper safe area handling
  * Implemented smooth animations for state changes
  * Added proper error handling and cleanup
  * Improved memory management
  * Enhanced visual hierarchy with consistent styling
* Added ability to toggle developer tools in release builds with secure gesture control


## 0.0.6
* Added support for advanced styling properties:
  * Background properties (fit, alignment, blend mode, repeat, clip, opacity)
  * Image and backdrop filters
  * Color filters for brightness/contrast
  * Drop shadow effects
  * Transform operations with alignment control
  * Percentage-based translations
  * Gradient support with colors and stops
* Enhanced overflow handling:
  * Added scroll overflow with axis control
  * Added hidden overflow option
  * Implemented bounce scroll physics
* Improved sizing capabilities:
  * Added fixed width/height support
  * Added relative width/height factors
  * Implemented aspect ratio control
* Added accessibility features:
  * Semantic labels
  * Focusable controls
* Implemented inset shadow support
* Added ring properties for focus outlines
* Enhanced text styling:
  * Added text indent
  * Added letter and word spacing
  * Added line height control
  * Added text overflow handling
  * Added text wrapping control
  * Added text selection behavior
  * Added text direction support
* Improved positioning system:
  * Added support for absolute, fixed, sticky positioning
  * Implemented inset controls (top, right, bottom, left)

## 0.0.7
* Added FlutterWind widget for app configuration:
  * Configurable loading screen
  * Developer tools integration
  * Theme and locale support
  * Media query handling
* Added developer tools features:
  * FPS counter
  * Memory usage monitor 
  * Build time tracking
  * Configurable background and text colors
* Improved configuration loading:
  * Asynchronous config loading
  * Error handling with logging
  * Loading state management
* Enhanced app initialization:
  * Support for custom routes
  * Initial route configuration
  * Route generation handling
  * Restoration scope support
* Added support for:
  * Custom shortcuts and actions
  * Scroll behavior configuration
  * Inherited media query control
  * Multiple locales

## 0.0.8

* Added plugin SDK foundations:
  * `FlutterWindClassHandler` + ordered handler registry.
  * Public utility handler registration API.
  * Preset registration/unregistration APIs.
* Added theme tokens v2 support:
  * Light/dark token sets via `theme.tokens`.
  * Brightness-aware semantic token resolution.
* Expanded runtime variants:
  * `group-focus`, `group-active`
  * `peer-hover`, `peer-focus`, `peer-active`, `peer-disabled`
* Added diagnostics mode plumbing:
  * Structured parser diagnostics model/collector.
  * Diagnostics panel integration in developer tools.
* Added benchmark harness:
  * Parser and variant benchmark tests.
  * Performance benchmark documentation.
* Added golden baseline automation:
  * Enabled and stabilized golden parity test.
  * Added baseline golden asset.
* Improved CLI:
  * `init` now generates token-v2-friendly `tailwind.config.yaml`.
  * CLI now runs as pure-Dart entrypoint for reliable execution.
