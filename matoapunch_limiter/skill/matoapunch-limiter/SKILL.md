---
name: matoapunch-limiter
description: Use this skill when working on the matoapunch_limiter Flutter/Dart package or when implementing, documenting, or integrating tier-based package limitations with TierPackage, Limitation, MatoapunchLimiter, LimitationAware, usage checks, feature gating, JSON plan definitions, or package-tier UI access control.
---

# Matoapunch Limiter

Use this skill when the task is specifically about this package's domain model or public API.

## What This Package Provides

- Tier/package modeling with `TierPackage`
- Atomic limitation modeling with `Limitation`
- Limitation typing with `LimitationType`
- Runtime usage evaluation through `MatoapunchLimiter`
- UI gating through `LimitationAware`

Read [references/package-reference.md](references/package-reference.md) when you need the current model semantics, usage patterns, or API examples.

## Working Rules

- Treat `MatoapunchLimiter` as the main public entry point.
- Preserve the current separation:
  - domain entities under `lib/src/domain`
  - package facade in `lib/src/matoapunch_limiter.dart`
  - Flutter widget wrappers under `lib/src/widgets`
- Keep `TierPackage.name` machine-readable and `TierPackage.displayName` human-readable.
- Keep `Limitation.name` as the stable machine-readable limitation identifier unless the task explicitly introduces a separate code field.
- Maintain snake_case JSON output. Parsing may accept camelCase fallbacks where the package already does.
- Do not add business-specific tier names or assumptions unless the user asks for them.

## Change Guidance

- For domain changes, update entities, exports, and tests together.
- For entry-point changes, expose behavior through `MatoapunchLimiter` instead of forcing consumers into `src/domain`.
- For UI gating changes, keep wrappers thin and delegate evaluation to `MatoapunchLimiter`.
- When changing semantics for `duration`, call out whether it remains numeric or becomes time-aware.

## Validation

- Prefer focused `flutter test` runs for touched files first.
- If public behavior changes, update `README.md` examples to match.

