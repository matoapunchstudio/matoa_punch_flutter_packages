import 'package:equatable/equatable.dart';
import 'package:matoapunch_rbac/src/domain/entities/permission.dart';

/// A role that groups permissions under a stable identifier and label.
class Role extends Equatable {
  /// Creates a role definition used by the RBAC domain.
  const Role({
    required this.name,
    required this.displayName,
    this.permissions = const [],
  });

  /// Creates a role from its JSON representation.
  factory Role.fromJson(Map<String, dynamic> json) {
    final permissionsJson = json['permissions'] as List<dynamic>? ?? const [];

    return Role(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
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
  final List<Permission> permissions;

  /// Converts this role into a JSON representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'displayName': displayName,
      'permissions': permissions
          .map((permission) => permission.toJson())
          .toList(growable: false),
    };
  }

  @override
  List<Object> get props => [name];
}
