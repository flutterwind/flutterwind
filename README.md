<div align="center">
<p align="center">
  <a href="https://flutterwind.dev" target="_blank">
    <img src="https://flutterwind.dev/img/logo.svg" alt="Tailwind CSS" width="70" height="70">
    <h1 align="center" style="color:red;">FlutterWind</h1>
  </a>
</p>

<p align="center">
<a href="https://pub.dev/packages/flutterwind"><img src="https://img.shields.io/pub/v/flutterwind.svg" alt="Pub"></a>
<a href="https://github.com/flutterwind/flutterwind"><img src="https://img.shields.io/github/stars/flutterwind/flutterwind.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://flutter.dev/docs/development/data-and-backend/state-mgmt/options#bloc--rx"><img src="https://img.shields.io/badge/flutter-website-deepskyblue.svg" alt="Flutter Website"></a>
<a href="https://github.com/Solido/awesome-flutter#standard"><img src="https://img.shields.io/badge/awesome-flutter-blue.svg?longCache=true" alt="Awesome Flutter"></a>
<a href="https://fluttersamples.com"><img src="https://img.shields.io/badge/flutter-samples-teal.svg?longCache=true" alt="Flutter Samples"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://discord.gg/flutterwind"><img src="https://img.shields.io/discord/649708778631200778.svg?logo=discord&color=blue" alt="Discord"></a>
</p>

</div>
<br />

# About

Do you like using [Tailwind CSS](https://tailwindcss.com) to style your apps? This helps you do that in [Flutter](https://flutter.dev). FlutterWind is **not** a component library, it's a styling library. If you're looking for component libraries that support FlutterWind, [see below](https://github.com/flutterwind/flutterwind/tree/%40danstepanov/docs-v4.1?tab=readme-ov-file#what-if-im-looking-for-a-component-library-that-uses-flutterwind).

FlutterWind makes sure you're using the best style engine for any given platform (e.g. CSS StyleSheet or StyleSheet.create). Its goals are to to provide a consistent styling experience across all platforms, improving developer UX, component performance, and code maintainability.

FlutterWind processes your styles during your application's build step and uses a minimal runtime to selectively apply reactive styles (eg changes to device orientation, light dark mode).

## Installation

If you have an existing project, [use these guides](https://www.flutterwind.dev/getting-started/installation) to configure FlutterWind for your respective stack.

## Features

- Works on **all** Flutter platforms, uses the best style system for each platform.
- Uses the Tailwind CSS compiler
- Styles are computed at **build time**
- Small runtime keeps your components fast
- Respects all tailwind.config.yaml settings, including **themes, custom values,** and **plugins**
- Support for
  - Custom CSS properties, aka **CSS Variables**
  - **Dark mode, arbitrary classes,** and **media queries**
  - **Animations** and **transitions**
  - **Container queries**
    - `container-type` and style-based container queries are not supported
  - Pseudo classes - **hover / focus / active** on compatible components
  - `rem` units
  - Theme functions and nested functions
  - Custom CSS
- Styling based on **parent state modifiers** - automatically style children based upon parent pseudo classes
  - Support for the `group` and `group/<name>` syntax
- **Children styles** - create simple layouts based upon parent class
- Fast and consistent style application via hot reload
- Includes changes made to `tailwind.config.yaml`

[More details here](https://www.flutterwind.dev/blog/announcement-flutterwind-v4#breaking-changes-from-v2)

## Contribution

[See this guide](https://github.com/flutterwind/flutterwind/blob/main/contributing.md)

# FAQ

## What if I'm looking for a component library that uses FlutterWind?

There are a number of different component libraries available that use FlutterWind to achieve different results. You should pick the one that best suits your needs.

### [FlutterWindUI](https://flutterwind.dev)

This multi-platform library focuses on achieving native feel for each individual platform using the familiar interface of Tailwind CSS.

## Documentation

Learn more on [our website](https://flutterwind.dev).