import 'package:equatable/equatable.dart';
import 'package:matoapunch_limiter/src/domain/entities/limitation.dart';

/// A sellable package or tier that groups multiple limitations.
class TierPackage extends Equatable {
  /// Creates a tier package definition.
  const TierPackage({
    required this.id,
    required this.code,
    required this.name,
    required this.displayName,
    required this.limitations,
    this.description = '',
    this.rank = 0,
    this.isActive = true,
  });

  /// Creates a tier package from its JSON representation.
  factory TierPackage.fromJson(Map<String, dynamic> json) {
    return TierPackage(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      displayName: (json['display_name'] ?? json['displayName']) as String,
      description: (json['description'] as String?) ?? '',
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      isActive: (json['is_active'] ?? json['isActive']) as bool? ?? true,
      limitations: (json['limitations'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => Limitation.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  /// Stable identifier for the package.
  final String id;

  /// Machine-readable package code.
  ///
  /// Example: `free`, `pro`, `enterprise`.
  final String code;

  /// Stable machine-readable package name.
  final String name;

  /// Human-readable package name.
  final String displayName;

  /// Optional package description.
  final String description;

  /// Ordering rank used for plan comparison or upgrade flow.
  final int rank;

  /// Whether this package is available for assignment or sale.
  final bool isActive;

  /// The set of limitations applied by this package.
  final List<Limitation> limitations;

  /// Finds a limitation by its stable key.
  Limitation? limitationByName(String name) {
    for (final limitation in limitations) {
      if (limitation.name == name) {
        return limitation;
      }
    }

    return null;
  }

  /// Converts this package into a snake_case JSON representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'display_name': displayName,
      'description': description,
      'rank': rank,
      'is_active': isActive,
      'limitations': limitations
          .map((limitation) => limitation.toJson())
          .toList(
            growable: false,
          ),
    };
  }

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    displayName,
    description,
    rank,
    isActive,
    limitations,
  ];
}
