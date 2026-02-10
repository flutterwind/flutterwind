# Performance Benchmarks

This document describes local benchmark workflows for FlutterWind parser and variant engine.

## Scope

- Parser throughput (`tokenizeFlutterWindClasses`, `applyClassToStyle`)
- Variant resolution path cost under repeated widget pumps

## Benchmark Files

- `test/benchmarks/parser_benchmark.dart`
- `test/benchmarks/variant_benchmark.dart`

## Local Execution

Run from repository root:

```bash
flutter test test/benchmarks/parser_benchmark.dart
flutter test test/benchmarks/variant_benchmark.dart
```

## Baseline Notes

Benchmarks are deterministic sanity checks, not hardware-agnostic guarantees.
Track results on your machine and compare deltas between commits.

## Regression Guidance

- Treat regressions greater than ~20% as suspicious.
- Confirm results with multiple runs before acting.
- Profile with DevTools when benchmarks regress.
