import 'package:matoapunch_limiter/src/domain/entities/limit_check_result.dart';
import 'package:matoapunch_limiter/src/domain/entities/limitation.dart';
import 'package:matoapunch_limiter/src/domain/entities/tier_package.dart';
import 'package:matoapunch_limiter/src/domain/entities/usage_snapshot.dart';
import 'package:matoapunch_limiter/src/domain/services/default_limiter_evaluator.dart';
import 'package:matoapunch_limiter/src/domain/services/limiter_evaluator.dart';

/// {@template matoapunch_limiter}
/// Entry point for package-tier limitation lookup and evaluation.
/// {@endtemplate}
class MatoapunchLimiter {
  /// {@macro matoapunch_limiter}
  const MatoapunchLimiter({
    LimiterEvaluator evaluator = const DefaultLimiterEvaluator(),
  }) : _evaluator = evaluator;

  final LimiterEvaluator _evaluator;

  /// Finds a limitation in a package by its stable name.
  Limitation? limitationByName({
    required TierPackage package,
    required String limitationName,
  }) {
    return package.limitationByName(limitationName);
  }

  /// Finds a limitation in a package by its stable code.
  ///
  /// This currently resolves against [Limitation.name].
  Limitation? limitationByCode({
    required TierPackage package,
    required String limitationCode,
  }) {
    return package.limitationByName(limitationCode);
  }

  /// Checks requested usage against a package limitation.
  LimitCheckResult check({
    required TierPackage package,
    required String limitationName,
    num currentUsage = 0,
    num requestedValue = 0,
  }) {
    return _evaluator.check(
      package: package,
      limitationName: limitationName,
      currentUsage: currentUsage,
      requestedValue: requestedValue,
    );
  }

  /// Checks requested usage using a usage snapshot.
  LimitCheckResult checkWithSnapshot({
    required TierPackage package,
    required UsageSnapshot usage,
    num requestedValue = 0,
  }) {
    return _evaluator.checkWithSnapshot(
      package: package,
      usage: usage,
      requestedValue: requestedValue,
    );
  }

  /// Returns whether a boolean-style feature is enabled for a package.
  bool isFeatureEnabled({
    required TierPackage package,
    required String limitationName,
  }) {
    return _evaluator.isFeatureEnabled(
      package: package,
      limitationName: limitationName,
    );
  }

  /// Creates a package model from JSON.
  TierPackage packageFromJson(Map<String, dynamic> json) {
    return TierPackage.fromJson(json);
  }

  /// Converts a package model into JSON.
  Map<String, dynamic> packageToJson(TierPackage package) {
    return package.toJson();
  }
}
