# Matoa Punch Studio Packages

This repository is the package monorepo for Matoa Punch Studio's shared Flutter and Dart libraries.

Each directory in this root is a standalone package with its own `pubspec.yaml`, tests, and package-level `README.md`.

## Packages

### `matoapunch_core`

Core functional types and clean architecture primitives used across other packages.

Main capabilities:

- `Result<T>` for success and failure outcomes
- `Option<T>` for optional values
- `Either<L, R>` for dual-branch results
- `AppUseCase<O, I>` as a base contract for use cases
- helper functions such as `safeCall`, `safeCallSync`, `ok`, `err`, `some`, `none`, `left`, and `right`
- `toResult()` extensions for values and futures

See [`matoapunch_core/README.md`](./matoapunch_core/README.md) for full API examples.

### `matoapunch_http`

HTTP utilities built around `chopper` for normalized request error handling.

Main capabilities:

- `HttpErrorInterceptor` for mapping transport and HTTP failures
- `ResponseException` as a structured request failure model
- `ConnectionResultStatus` for classifying network outcomes

Typical use case:

- add the interceptor to a `ChopperClient`
- catch `ResponseException`
- branch on timeout, offline, or generic error states in a consistent way

See [`matoapunch_http/README.md`](./matoapunch_http/README.md) for usage and error-mapping details.

### `matoapunch_limiter`

Tier and limitation modeling package for products with plan-based access control or quotas.

Main capabilities:

- define package tiers with `TierPackage`
- define limits and feature flags with `Limitation`
- evaluate usage with `MatoapunchLimiter`
- serialize tier and limitation data to and from JSON
- conditionally render UI with `LimitationAware`

Typical use cases:

- enforce quotas such as max projects, max users, or storage limits
- gate feature access by subscription plan
- share package limitation rules between app logic and UI

See [`matoapunch_limiter/README.md`](./matoapunch_limiter/README.md) for examples.

### `matoapunch_pocketbase`

Lightweight PocketBase integration package for shared user and admin auth flows in Flutter apps.

Main capabilities:

- shared `PocketBase` clients for user and admin access
- persisted auth state with `shared_preferences`
- automatic auth refresh during initialization when stored tokens are still valid
- explicit facade APIs for `user`, `admin`, `userClient`, and `adminClient`
- `PbErrorMessage` for PocketBase field-level error mapping

Typical use cases:

- initialize shared PocketBase access once at app startup
- restore persisted sessions for user and admin flows
- keep auth handling consistent across multiple Flutter apps
- centralize PocketBase wrapper logic instead of duplicating setup code

See [`matoapunch_pocketbase/README.md`](./matoapunch_pocketbase/README.md) for setup and usage examples.

### `matoapunch_rbac`

Lightweight RBAC utilities for modeling permissions and roles in Flutter and Dart apps.

Main capabilities:

- immutable permission state via `MatoapunchRbac`
- domain entities for `Permission` and `Role`
- JSON and base64 encoding helpers
- permission check extensions
- `RbacGuard` for permission-based UI protection

Typical use cases:

- checking access to screens, actions, or menus
- building RBAC state from roles or encoded permission payloads
- sharing permission evaluation logic between backend responses and frontend widgets

See [`matoapunch_rbac/README.md`](./matoapunch_rbac/README.md) for the full package guide.

## Repository Structure

```text
packages/
├── matoapunch_core/
├── matoapunch_http/
├── matoapunch_limiter/
├── matoapunch_pocketbase/
├── matoapunch_rbac/
└── README.md
```

## Environment

Current package constraints are not fully uniform yet:

- `matoapunch_core` and `matoapunch_http` target Dart `^3.9.0` and Flutter `^3.35.0`
- `matoapunch_pocketbase` also targets Dart `^3.9.0` and Flutter `^3.35.0`
- `matoapunch_limiter` and `matoapunch_rbac` target Dart `^3.11.0` and Flutter `^3.41.0`

When working across the whole repository, use a Flutter SDK version that satisfies the highest package requirement.

## Local Development

This root does not currently include a workspace manager such as `melos`, `pnpm`, or `turbo`.

That means:

- each package is managed independently
- commands are usually run from inside the individual package directory
- cross-package consumption is typically done through local path dependencies

Example path dependency:

```yaml
dependencies:
  matoapunch_core:
    path: ../matoapunch_core
```

## Common Commands

Run these from a package directory:

```sh
flutter pub get
dart analyze
flutter test
```

For packages that use code generation, also run:

```sh
dart run build_runner build --delete-conflicting-outputs
```

At the moment, `matoapunch_core` and `matoapunch_pocketbase` are the packages in this repo that clearly depend on code generation tooling such as `freezed` and `json_serializable`.

## Notes

- All packages are currently internal packages with `publish_to: none`
- package-level READMEs remain the source of truth for detailed API usage
- some package `pubspec.yaml` descriptions still contain scaffold defaults, so this root README is the clearer high-level map of the repo
