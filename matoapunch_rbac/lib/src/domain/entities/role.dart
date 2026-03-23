import 'package:equatable/equatable.dart';
import 'package:matoapunch_rbac/src/domain/abstracts/should_have_permission.dart';
import 'package:matoapunch_rbac/src/domain/entities/permission.dart';

/// A role that groups permissions under a stable identifier and label.
class Role extends Equatable implements ShouldHavePermission {
  /// Creates a role definition used by the RBAC domain.
  const Role({
    required this.name,
    required this.displayName,
    this.permissions = const [],
  });

  /// Creates a role from its JSON representation.
  factory Role.fromJson(Map<String, dynamic> json) {
    final permissionsJson = json['permissions'] as List<dynamic>? ?? const [];
    final displayName =
        (json['display_name'] ?? json['displayName']) as String;

    return Role(
      name: json['name'] as String,
      displayName: displayName,
      permissions: permissionsJson
          .map(
            (permission) =>
                Permission.fromJson(permission as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  /// The stable machine-readable role identifier.
  final String name;

  /// The human-readable role label intended for display.
  final String displayName;

  /// The permissions grouped under this role.
  @override
  final List<Permission> permissions;

  /// Converts this role into a snake_case JSON representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'display_name': displayName,
      'permissions': permissions
          .map((permission) => permission.toJson())
          .toList(growable: false),
    };
  }

  @override
  List<Object> get props => [name];
}
