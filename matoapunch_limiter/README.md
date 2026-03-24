# Matoapunch Limiter

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

`matoapunch_limiter` is a Flutter/Dart package for modeling and evaluating tier-based package limitations.

It is intended for products that sell multiple plans such as `free`, `pro`, and `enterprise`, where each tier exposes different quotas or feature flags.

## Features

- Model tier/package definitions with multiple limitations
- Support different limitation types:
  - `count`
  - `boolean`
  - `duration`
  - `size`
- Evaluate usage through a single entry point: `MatoapunchLimiter`
- Serialize packages and limitations to and from JSON
- Render UI conditionally with `LimitationAware`

## Installation

```sh
dart pub add matoapunch_limiter
```

## Core Concepts

### `Limitation`

Represents one limit inside a package.

```dart
const limitation = Limitation(
  name: 'max_projects',
  displayName: 'Maximum Projects',
  type: LimitationType.count,
  value: 5,
);
```

Fields:

- `name`: stable machine-readable limitation key
- `displayName`: human-readable label
- `description`: optional explanation
- `type`: limitation type
- `value`: configured value, where `null` means unlimited

### `TierPackage`

Represents one sellable plan or package.

```dart
final proPackage = TierPackage(
  id: 'pkg_pro',
  code: 'pro',
  name: 'pro',
  displayName: 'Pro',
  limitations: [
    Limitation(
      name: 'max_projects',
      displayName: 'Maximum Projects',
      type: LimitationType.count,
      value: 10,
    ),
    Limitation(
      name: 'enable_export',
      displayName: 'Export Feature',
      type: LimitationType.boolean,
      value: 1,
    ),
  ],
);
```

Fields:

- `id`: stable package identifier
- `code`: machine-readable plan code such as `free` or `pro`
- `name`: stable package name used internally
- `displayName`: label intended for UI
- `limitations`: list of package limitations

## Entry Point API

`MatoapunchLimiter` is the main entry point of this package.

```dart
const limiter = MatoapunchLimiter();
```

### Find a limitation

```dart
final limitation = limiter.limitationByName(
  package: proPackage,
  limitationName: 'max_projects',
);
```

### Check numeric usage

```dart
final result = limiter.check(
  package: proPackage,
  limitationName: 'max_projects',
  currentUsage: 7,
  requestedValue: 2,
);

if (result.isAllowed) {
  // proceed
}
```

### Check with `UsageSnapshot`

```dart
final result = limiter.checkWithSnapshot(
  package: proPackage,
  usage: const UsageSnapshot(
    name: 'max_projects',
    currentValue: 7,
  ),
  requestedValue: 2,
);
```

### Check feature flags

```dart
final canExport = limiter.isFeatureEnabled(
  package: proPackage,
  limitationName: 'enable_export',
);
```

## JSON Support

Both `Limitation` and `TierPackage` support JSON serialization.

```dart
final json = proPackage.toJson();
final restored = TierPackage.fromJson(json);
```

`TierPackage.fromJson` accepts:

- `display_name`
- `displayName`
- `is_active`
- `isActive`

`Limitation.fromJson` accepts:

- `display_name`
- `displayName`

## Widget Wrapper

Use `LimitationAware` to show or hide UI based on a package limitation.

### Feature flag example

```dart
LimitationAware(
  package: proPackage,
  limitationName: 'enable_export',
  asFeatureFlag: true,
  fallback: const SizedBox.shrink(),
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Export'),
  ),
)
```

### Numeric limit example

```dart
LimitationAware(
  package: proPackage,
  limitationName: 'max_projects',
  currentUsage: 9,
  requestedValue: 1,
  fallback: const Text('Project limit reached'),
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Create Project'),
  ),
)
```

## Limitation Types

- `LimitationType.count`: numeric cap such as max projects or max members
- `LimitationType.boolean`: feature toggle, usually `1` for enabled and `0` for disabled
- `LimitationType.duration`: duration value represented numerically
- `LimitationType.size`: size value represented numerically, usually bytes

## Notes

- `null` limitation values are treated as unlimited
- `limitationByCode` currently resolves against `Limitation.name`
- `duration` is currently evaluated as a numeric value, not as a date-aware expiry rule

## Running Tests

```sh
flutter test
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
