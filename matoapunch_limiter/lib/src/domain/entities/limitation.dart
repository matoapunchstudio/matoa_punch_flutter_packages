import 'package:equatable/equatable.dart';
import 'package:matoapunch_limiter/src/domain/entities/limitation_type.dart';

/// A single constraint within a tiered package.
class Limitation extends Equatable {
  /// Creates a limitation definition used by the limiter domain.
  const Limitation({
    required this.name,
    required this.displayName,
    required this.type,
    this.description = '',
    this.value,
  });

  /// Creates a limitation from its JSON representation.
  factory Limitation.fromJson(Map<String, dynamic> json) {
    final displayName = (json['display_name'] ?? json['displayName']) as String;

    return Limitation(
      name: json['name'] as String,
      displayName: displayName,
      description: (json['description'] as String?) ?? '',
      type: LimitationType.values.byName(json['type'] as String),
      value: json['value'] as num?,
    );
  }

  /// The stable machine-readable limitation identifier.
  ///
  /// Example: `max_projects`, `enable_export`, `trial_period`.
  final String name;

  /// The human-readable limitation label intended for display.
  ///
  /// Example: "Maximum Projects", "Export Feature", "Trial Period".
  final String displayName;

  /// An optional description explaining what this limitation controls.
  final String description;

  /// The kind of constraint this limitation represents.
  final LimitationType type;

  /// The limit value.
  ///
  /// Interpretation depends on [type]:
  /// - [LimitationType.count]: the numeric cap (e.g. `5`).
  /// - [LimitationType.boolean]: `1` for enabled, `0` for disabled.
  /// - [LimitationType.duration]: duration in seconds
  ///   (e.g. `2592000` for 30 days).
  /// - [LimitationType.size]: size in bytes (e.g. `524288000` for 500 MB).
  ///
  /// A `null` value means unlimited / unrestricted.
  final num? value;

  /// Whether this limitation imposes no restriction.
  bool get isUnlimited => value == null;

  /// Converts this limitation into a snake_case JSON representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'display_name': displayName,
      'description': description,
      'type': type.name,
      'value': value,
    };
  }

  @override
  List<Object?> get props => [name];
}
