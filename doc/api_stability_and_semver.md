# API Stability and SemVer Policy

This document defines FlutterWind's public API stability contract and versioning policy.

## Public API Surface

The following are considered stable public APIs:

- `package:flutterwind_core/flutterwind.dart` exports
- `FlutterWindExtension.className(...)`
- `TailwindConfig` read APIs and config loading behavior
- `FlutterWindTheme` APIs

Internal files under `lib/src/**` are implementation details unless explicitly exported via `flutterwind.dart`.

## Stability Levels

- `stable`: safe for production usage; breaking changes require deprecation cycle.
- `experimental`: may change in minor releases; clearly documented in release notes.
- `internal`: no compatibility guarantees.

## Deprecation Workflow

Any breaking change to a stable API must follow:

1. Add deprecation annotation and migration note.
2. Keep old API functional for at least one minor release.
3. Remove in the next major release only.

## Semantic Versioning Rules

- `PATCH`: bug fixes and internal improvements only.
- `MINOR`: additive features and new non-breaking APIs.
- `MAJOR`: breaking changes only, with migration guide.

## Migration Documentation

For each deprecation/removal:

- mention old API and new API
- provide before/after code example
- include target removal version

## Compatibility Guardrails

- New features should be opt-in by default.
- Existing class utility behavior should not change silently.
- Runtime parser semantics and generated support matrix must stay aligned.
