import 'package:matoapunch_rbac/src/domain/entities/permission.dart';
import 'package:matoapunch_rbac/src/domain/entities/role.dart';
import 'package:matoapunch_rbac/src/utils/rbac_codec.dart';

/// {@template matoapunch_rbac}
/// Stores and evaluates an immutable RBAC permission set.
///
/// Permission identity is based on the stable `name` field.
/// A role can be projected into an RBAC state through
/// [MatoapunchRbac.fromRole].
/// {@endtemplate}
class MatoapunchRbac {
  /// Creates an immutable RBAC state object.
  factory MatoapunchRbac({
    List<Permission> permissions = const [],
  }) {
    final normalizedPermissions = permissions.toList(growable: false);

    if (normalizedPermissions.isEmpty) {
      return const MatoapunchRbac._(
        permissions: [],
        permissionNames: {},
      );
    }

    return MatoapunchRbac._(
      permissions: List.unmodifiable(normalizedPermissions),
      permissionNames: Set.unmodifiable(
        normalizedPermissions.map((permission) => permission.name),
      ),
    );
  }

  /// Creates an RBAC state object from encoded permissions.
  factory MatoapunchRbac.fromEncodedPermissions(String encodedPermissions) {
    return MatoapunchRbac(
      permissions: RbacCodec.decodePermissions(encodedPermissions),
    );
  }

  /// Creates an RBAC state object from the permissions granted by [role].
  factory MatoapunchRbac.fromRole(Role role) =>
      MatoapunchRbac(permissions: role.permissions);

  /// Creates an RBAC state object from the combined permissions of [roles].
  ///
  /// When [roles] is empty, this returns an empty RBAC state.
  factory MatoapunchRbac.fromAnyRole(List<Role> roles) {
    if (roles.isEmpty) {
      return MatoapunchRbac();
    }

    final permissions = roles
        .map((e) => e.permissions)
        .reduce((a, b) => a + b)
        .toList(growable: false);

    return MatoapunchRbac(permissions: permissions);
  }

  const MatoapunchRbac._({
    required List<Permission> permissions,
    required Set<String> permissionNames,
  }) : _permissions = permissions,
       _permissionNames = permissionNames;

  final List<Permission> _permissions;
  final Set<String> _permissionNames;

  /// The active permissions as an immutable list.
  List<Permission> get permissions => _permissions;

  /// Encodes the active permissions into a base64 string.
  String encodePermissions() => RbacCodec.encodePermissions(_permissions);

  /// Returns `true` when the active set contains [permission].
  bool hasPermission(
    Permission permission,
  ) => _permissions.contains(permission);

  /// Returns `true` when the active set contains [permissionName].
  bool hasPermissionByName(String permissionName) =>
      _permissionNames.contains(permissionName);

  /// Returns `true` when any of [permissions] exists in the active set.
  bool hasAnyPermissions(List<Permission> permissions) =>
      permissions.any(hasPermission);

  /// Returns `true` when any of [permissionNames] exists in the active set.
  bool hasAnyPermissionsByName(List<String> permissionNames) =>
      permissionNames.any(hasPermissionByName);
}
