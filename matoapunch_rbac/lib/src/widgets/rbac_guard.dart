import 'package:flutter/widgets.dart';
import 'package:matoapunch_rbac/src/domain/entities/permission.dart';
import 'package:matoapunch_rbac/src/domain/entities/role.dart';
import 'package:matoapunch_rbac/src/matoapunch_rbac.dart';

/// Defines how [RbacGuard] evaluates a permission list.
enum RbacGuardMatch {
  /// Grants access when any permission in the list is present.
  any,

  /// Grants access only when all permissions in the list are present.
  all,
}

/// A widget that conditionally renders content based on granted permissions.
///
/// The [permissions] list must not be empty. By default, access is granted
/// when any permission in [permissions] exists in [rbac]. Set [match] to
/// [RbacGuardMatch.all] to require every permission instead.
class RbacGuard extends StatelessWidget {
  /// Creates a permission-aware widget wrapper.
  const RbacGuard({
    required this.rbac,
    required this.permissions,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    this.match = RbacGuardMatch.any,
    super.key,
  }) : assert(
         permissions.length > 0,
         'permissions must not be empty',
       );

  /// Creates a permission-aware widget wrapper from raw permissions.
  RbacGuard.fromPermissions({
    required List<Permission> grantedPermissions,
    required this.permissions,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    this.match = RbacGuardMatch.any,
    super.key,
  }) : assert(
         permissions.isNotEmpty,
         'permissions must not be empty',
       ),
       rbac = MatoapunchRbac(permissions: grantedPermissions);

  /// Creates a permission-aware widget wrapper from a single role.
  RbacGuard.fromRole({
    required Role role,
    required this.permissions,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    this.match = RbacGuardMatch.any,
    super.key,
  }) : assert(
         permissions.isNotEmpty,
         'permissions must not be empty',
       ),
       rbac = MatoapunchRbac.fromRole(role);

  /// Creates a permission-aware widget wrapper from multiple roles.
  RbacGuard.fromRoles({
    required List<Role> roles,
    required this.permissions,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    this.match = RbacGuardMatch.any,
    super.key,
  }) : assert(
         permissions.isNotEmpty,
         'permissions must not be empty',
       ),
       rbac = MatoapunchRbac.fromAnyRole(roles);

  /// The RBAC state used to evaluate access.
  final MatoapunchRbac rbac;

  /// The permission names required for access.
  final List<String> permissions;

  /// The widget shown when access is granted.
  final Widget child;

  /// The widget shown when access is denied.
  final Widget fallback;

  /// The strategy used to evaluate [permissions].
  final RbacGuardMatch match;

  @override
  Widget build(BuildContext context) {
    final isGranted = switch (match) {
      RbacGuardMatch.any => rbac.hasAnyPermissionsByName(permissions),
      RbacGuardMatch.all => permissions.every(rbac.hasPermissionByName),
    };

    return isGranted ? child : fallback;
  }
}
