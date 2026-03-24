import 'package:equatable/equatable.dart';
import 'package:matoapunch_limiter/src/domain/entities/limitation.dart';

/// Result of evaluating a limitation against current usage.
class LimitCheckResult extends Equatable {
  /// Creates a limit check result.
  const LimitCheckResult({
    required this.name,
    required this.isAllowed,
    this.limit,
    this.currentUsage,
    this.requestedValue,
    this.reason,
  });

  /// Stable limitation key.
  final String name;

  /// Whether the evaluated action is allowed.
  final bool isAllowed;

  /// The matched limitation definition, if one exists.
  final Limitation? limit;

  /// Current consumed value used for the evaluation.
  final num? currentUsage;

  /// Requested value used for the evaluation.
  final num? requestedValue;

  /// Optional explanation when the action is denied or unresolved.
  final String? reason;

  @override
  List<Object?> get props => [
    name,
    isAllowed,
    limit,
    currentUsage,
    requestedValue,
    reason,
  ];
}
