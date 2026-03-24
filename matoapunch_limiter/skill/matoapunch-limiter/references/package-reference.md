# Package Reference

## Public Entry Points

- `lib/matoapunch_limiter.dart`
- `lib/src/matoapunch_limiter.dart`
- `lib/src/widgets/limitation_aware.dart`

## Domain Model

### `Limitation`

Represents one package constraint.

Fields:

- `name`: stable machine-readable key such as `max_projects`
- `displayName`: human-readable label
- `description`: optional explanation
- `type`: `count`, `boolean`, `duration`, or `size`
- `value`: configured limit; `null` means unlimited

Current semantics:

- equality is keyed by `name`
- JSON output is snake_case
- `display_name` and `displayName` are accepted during parsing

### `TierPackage`

Represents one sellable package or plan.

Fields:

- `id`
- `code`
- `name`: machine-readable
- `displayName`: human-readable
- `description`
- `rank`
- `isActive`
- `limitations`

Current semantics:

- package JSON emits `display_name` and `is_active`
- limitation lookup is currently by `Limitation.name`

### `UsageSnapshot`

Represents current consumed usage for one limitation key.

Use it when usage already exists as a domain object rather than separate primitive values.

### `LimitCheckResult`

Represents the result of one evaluation.

Important fields:

- `isAllowed`: whether the action can proceed
- `currentUsage`: already consumed amount
- `requestedValue`: the new amount being attempted
- `reason`: denial or resolution message

## Evaluator Behavior

`DefaultLimiterEvaluator` currently behaves as follows:

- `boolean`: allowed when `value == 1`
- `count`, `size`, `duration`: allowed when `currentUsage + requestedValue <= value`
- `null` value: unlimited
- missing limitation: denied

`duration` is currently treated as numeric, not date-aware.

## UI Wrapper

### `LimitationAware`

Use for conditional rendering.

- `asFeatureFlag: true` uses `isFeatureEnabled`
- otherwise it uses numeric `check`
- `fallback` defaults to `SizedBox.shrink()`

## Typical Tasks This Skill Should Support

- add a new limitation type
- add package-level lookup or helper methods
- expose more public API through `MatoapunchLimiter`
- build builder-style widgets around `LimitCheckResult`
- update docs/examples to reflect current package semantics

