import 'package:equatable/equatable.dart';

/// Current usage value for a specific limitation key.
class UsageSnapshot extends Equatable {
  /// Creates a usage snapshot entry.
  const UsageSnapshot({
    required this.name,
    required this.currentValue,
  });

  /// Creates a usage snapshot from its JSON representation.
  factory UsageSnapshot.fromJson(Map<String, dynamic> json) {
    return UsageSnapshot(
      name: json['name'] as String,
      currentValue: json['current_value'] as num,
    );
  }

  /// Stable limitation key.
  final String name;

  /// Current consumed value for the limitation.
  final num currentValue;

  /// Converts this snapshot into a snake_case JSON representation.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'current_value': currentValue,
    };
  }

  @override
  List<Object> get props => [name, currentValue];
}
