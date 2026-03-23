import 'package:equatable/equatable.dart';

/// A permission that represents a single access capability in RBAC.
class Permission extends Equatable {
  /// Creates a permission definition used by the RBAC domain.
  const Permission({required this.name, required this.displayName});

  /// Creates a permission from its JSON representation.
  factory Permission.fromJson(Map<String, dynamic> json) {
    final displayName =
        (json['display_name'] ?? json['displayName']) as String;

    return Permission(
      name: json['name'] as String,
      displayName: displayName,
    );
  }

  /// The stable machine-readable permission identifier.
  final String name;

  /// The human-readable permission label intended for display.
  final String displayName;

  /// Converts this permission into a snake_case JSON representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'display_name': displayName,
    };
  }

  @override
  List<Object> get props => [name];
}
