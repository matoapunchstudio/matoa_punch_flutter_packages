# Package Reference

## Public Imports

Use the full package import when consumers need the complete API:

```dart
import 'package:matoapunch_rbac/matoapunch_rbac.dart';
```

Use area imports when callers want narrower access:

```dart
import 'package:matoapunch_rbac/domain.dart';
import 'package:matoapunch_rbac/extensions.dart';
import 'package:matoapunch_rbac/utils.dart';
import 'package:matoapunch_rbac/widgets.dart';
```

## Core Types

### Permission

- Fields:
  - `name`: stable permission identifier used for equality and checks
  - `displayName`: human-readable label
- Equality is based on `name`
- `toJson()` writes:

```json
{
  "name": "user.read",
  "display_name": "Read User"
}
```

- `Permission.fromJson()` accepts both `display_name` and legacy `displayName`

### Role

- Fields:
  - `name`: stable role identifier
  - `displayName`: human-readable role label
  - `permissions`: granted `List<Permission>`
- Implements `ShouldHavePermission`
- Equality is based on `name`
- `Role.fromJson()` accepts both `display_name` and legacy `displayName`
- `toJson()` writes snake_case output and serializes nested permissions

### ShouldHavePermission

- Contract for any object exposing `List<Permission> permissions`
- Enables reuse of the permission-check extensions on non-role types

## MatoapunchRbac

Use `MatoapunchRbac` as the primary runtime permission evaluator.

- Constructors:
  - `MatoapunchRbac(permissions: [...])`
  - `MatoapunchRbac.fromEncodedPermissions(encoded)`
  - `MatoapunchRbac.fromRole(role)`
  - `MatoapunchRbac.fromAnyRole(roles)`
- Behavior:
  - stores an immutable permission list
  - caches permission names for name-based checks
  - returns an empty RBAC state when built from an empty role list
- Main methods:
  - `hasPermission(permission)`
  - `hasPermissionByName(permissionName)`
  - `hasAnyPermissions(permissions)`
  - `hasAnyPermissionsByName(permissionNames)`
  - `encodePermissions()`

## Extensions

Permission-check helpers exist on:

- `ShouldHavePermission`
- `Role`
- `List<ShouldHavePermission>`
- `List<Role>`

These wrappers delegate to `MatoapunchRbac`. Keep them ergonomic and aligned with the main runtime semantics.

## Codec Helpers

`RbacCodec` converts permission lists to and from base64-encoded JSON.

- `RbacCodec.encodePermissions(List<Permission>)`
- `RbacCodec.decodePermissions(String)`

Use this when permissions need to be transported or stored as a compact string.

## Widget Guard

`RbacGuard` conditionally renders UI based on granted permission names.

- Main constructor:
  - `RbacGuard(rbac: ..., permissions: ..., child: ...)`
- Convenience constructors:
  - `RbacGuard.fromPermissions(...)`
  - `RbacGuard.fromRole(...)`
  - `RbacGuard.fromRoles(...)`
- Matching:
  - `RbacGuardMatch.any`: access granted if any required permission matches
  - `RbacGuardMatch.all`: access granted only if all required permissions match
- Fallback:
  - defaults to `SizedBox.shrink()`
- Guardrails:
  - `permissions` must not be empty

## Package Conventions

- Prefer machine-readable dotted permission names such as `user.read`
- Keep serialization output in snake_case
- Preserve backward-compatible reads for stored permission and role payloads
- Prefer the package facade and public exports over importing from `src/`
