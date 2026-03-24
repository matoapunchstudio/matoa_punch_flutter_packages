---
name: matoapunch-rbac
description: Use this skill when working on the matoapunch_rbac Flutter/Dart package or when implementing, documenting, or integrating role-based access control with Permission, Role, MatoapunchRbac, ShouldHavePermission, RbacCodec, permission-check extensions, or the RbacGuard widget.
---

# Matoapunch RBAC

Use this skill when the task is specifically about this package's domain model or public API.

## What This Package Provides

- Permission modeling with `Permission`
- Role modeling with `Role`
- Immutable RBAC state through `MatoapunchRbac`
- Permission-check helpers on roles and permission-carrying objects
- Base64 encode/decode helpers through `RbacCodec`
- UI gating through `RbacGuard`

Read [references/package-reference.md](references/package-reference.md) when you need the current model semantics, JSON rules, or API usage patterns.

## Working Rules

- Treat `MatoapunchRbac` as the main runtime entry point for permission evaluation.
- Preserve the current separation:
  - domain entities under `lib/src/domain`
  - runtime facade in `lib/src/matoapunch_rbac.dart`
  - extensions under `lib/src/extensions`
  - codec helpers under `lib/src/utils`
  - Flutter widget wrappers under `lib/src/widgets`
- Keep `Permission.name` and `Role.name` as the stable machine-readable identifiers.
- Keep `displayName` as the human-readable label for both permissions and roles.
- Maintain snake_case JSON output. Parsing may accept both `display_name` and legacy `displayName` where the package already does.
- Keep widget wrappers thin and delegate access evaluation to `MatoapunchRbac`.
- Do not introduce app-specific roles or permission names unless the user asks for them.

## Change Guidance

- For domain changes, update entities, exports, tests, and README examples together.
- For permission evaluation changes, prefer exposing behavior through `MatoapunchRbac` and keeping extensions as ergonomic wrappers.
- For serialization changes, preserve backward-compatible reads unless the user explicitly wants a breaking change.
- For UI access control changes, keep `RbacGuard` behavior explicit about `any` versus `all` matching.

## Validation

- Prefer focused `flutter test` runs for touched files first.
- If public behavior changes, update `README.md` examples to match the package API.
