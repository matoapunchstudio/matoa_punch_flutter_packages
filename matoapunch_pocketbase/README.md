# matoapunch_pocketbase

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A lightweight PocketBase wrapper for MatoaPunch Studio Flutter projects.

It provides:
- shared user and admin PocketBase clients
- persisted auth tokens with `shared_preferences`
- auth refresh during initialization when a stored token is still valid
- a small facade for explicit `user` and `admin` access

## Package Constraints

This package currently uses one consistent toolchain:
- Dart SDK: `^3.9.0`
- Flutter SDK: `^3.35.0`
- CI Flutter version: `3.35.x`

Core runtime dependencies:
- `matoapunch_core`
- `pocketbase ^0.23.2`
- `shared_preferences ^2.5.4`

Code generation and linting:
- `freezed_annotation ^3.1.0`
- `json_annotation ^4.11.0`
- `build_runner ^2.13.1`
- `freezed ^3.2.5`
- `json_serializable ^6.13.1`
- `very_good_analysis ^10.2.0`

## Installation

Add the package:

```sh
dart pub add matoapunch_pocketbase
```

The package depends on Flutter because it uses `shared_preferences`.

For local development, use the same Flutter line as CI:

```sh
flutter --version
```

You should be on Flutter `3.35.x`.

## Required Configuration

This package expects your PocketBase base URL through a compile-time define:

```sh
flutter run --dart-define=PB_BASE_URL=https://your-pocketbase-url
```

If `PB_BASE_URL` is missing, the PocketBase client will still be created with an
empty base URL, which is not useful in practice. Set it explicitly in every
runtime environment.

### Optional Development Defines

`simulateLogin()` on the user client requires these optional defines:

```sh
flutter run \
  --dart-define=PB_BASE_URL=https://your-pocketbase-url \
  --dart-define=PB_SIMULATED_EMAIL=dev@example.com \
  --dart-define=PB_SIMULATED_PASSWORD=secret
```

## Quick Start

Import the package:

```dart
import 'package:matoapunch_pocketbase/matoapunch_pocketbase.dart';
```

Initialize the wrapper before reading any PocketBase client:

```dart
final pb = MatoapunchPocketbase();

await pb.init();
```

After initialization you can access explicit user and admin clients:

```dart
final userClient = pb.userClient;
final adminClient = pb.adminClient;
```

## API Overview

### Main facade

`MatoapunchPocketbase` is a singleton facade.

```dart
final pb = MatoapunchPocketbase();
```

Available members:
- `init()`: initializes both persisted user and admin auth clients
- `user`: returns the shared `PbSingleton`
- `admin`: returns the shared `PbAdminSingleton`
- `userClient`: returns the initialized user `PocketBase`
- `adminClient`: returns the initialized admin `PocketBase`
- `pbUser`: legacy alias for `user`
- `pbAdmin`: legacy alias for `admin`

### User client

`PbSingleton` is the shared user auth manager.

Common methods:
- `setup()`
- `refresh()`
- `updateAuth(RecordAuth auth)`
- `loginWithEmailAndPassword(String email, String password)`
- `simulateLogin()`
- `pocketBase`

### Admin client

`PbAdminSingleton` is the shared admin auth manager.

Common methods:
- `setup()`
- `refresh()`
- `updateAuth(RecordAuth auth)`
- `loginWithEmailAndPassword(String email, String password)`
- `pocketBase`

## Recommended Usage

Prefer explicit access instead of mode switching:

```dart
final pb = MatoapunchPocketbase();
await pb.init();

final userPocketBase = pb.userClient;
final adminPocketBase = pb.adminClient;
```

This is clearer than relying on a mutable selector flag.

## Authentication Examples

### User login

```dart
final pb = MatoapunchPocketbase();
await pb.init();

final userRecord = await pb.user.loginWithEmailAndPassword(
  'user@example.com',
  'password',
);

print(userRecord.id);
```

### Admin login

```dart
final pb = MatoapunchPocketbase();
await pb.init();

final adminRecord = await pb.admin.loginWithEmailAndPassword(
  'admin@example.com',
  'password',
);

print(adminRecord.id);
```

### Using a `RecordAuth` response

If you already have a `RecordAuth` response from another flow, persist it
through `updateAuth()`:

```dart
final record = pb.user.updateAuth(authResponse);
```

The token is stored and the internal PocketBase client is rebuilt with the new
auth state.

## Session Behavior

During `init()`:
- the package restores saved user and admin tokens from `shared_preferences`
- it builds PocketBase clients for both modes
- if a stored token is still marked valid by PocketBase, it attempts `refresh()`

During `refresh()` failure:
- the failure is logged
- the stored auth state is cleared
- a fresh unauthenticated PocketBase client is rebuilt

This avoids silently keeping stale auth sessions in memory.

## Error Handling

Accessing `userClient`, `adminClient`, `user.pocketBase`, or `admin.pocketBase`
before `init()` throws a `StateError` with a clear message.

Example:

```dart
final pb = MatoapunchPocketbase();
final client = pb.userClient; // throws until init() has been called
```

## PocketBase Error Entity

The package exposes `PbErrorMessage`, a small model for PocketBase field-level
errors.

```dart
final error = PbErrorMessage.fromExceptionResponse('email', {
  'code': 'validation_invalid_email',
  'message': 'Invalid email address',
});
```

## Legacy API Notes

Older code may still reference:
- `pbUser`
- `pbAdmin`

These aliases still work.

If your local branch still has `isAdmin` / `pocketbase`, treat that as legacy
API and prefer explicit `userClient` or `adminClient` access in new code.

## Testing

Run the package checks with:

```sh
flutter analyze
flutter test
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
