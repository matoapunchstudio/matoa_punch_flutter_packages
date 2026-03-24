import 'package:matoapunch_limiter/src/domain/entities/limit_check_result.dart';
import 'package:matoapunch_limiter/src/domain/entities/limitation_type.dart';
import 'package:matoapunch_limiter/src/domain/entities/tier_package.dart';
import 'package:matoapunch_limiter/src/domain/entities/usage_snapshot.dart';
import 'package:matoapunch_limiter/src/domain/services/limiter_evaluator.dart';

/// Default evaluator for count, boolean, duration, and size limitations.
class DefaultLimiterEvaluator implements LimiterEvaluator {
  /// Creates a default limiter evaluator.
  const DefaultLimiterEvaluator();

  @override
  LimitCheckResult check({
    required TierPackage package,
    required String limitationName,
    num currentUsage = 0,
    num requestedValue = 0,
  }) {
    final limitation = package.limitationByName(limitationName);
    if (limitation == null) {
      return LimitCheckResult(
        name: limitationName,
        isAllowed: false,
        currentUsage: currentUsage,
        requestedValue: requestedValue,
        reason: 'Limitation not found in package.',
      );
    }

    if (limitation.isUnlimited) {
      return LimitCheckResult(
        name: limitationName,
        isAllowed: true,
        limit: limitation,
        currentUsage: currentUsage,
        requestedValue: requestedValue,
      );
    }

    switch (limitation.type) {
      case LimitationType.boolean:
        final isEnabled = limitation.value == 1;
        return LimitCheckResult(
          name: limitationName,
          isAllowed: isEnabled,
          limit: limitation,
          currentUsage: currentUsage,
          requestedValue: requestedValue,
          reason: isEnabled ? null : 'Feature is disabled for this package.',
        );
      case LimitationType.count:
      case LimitationType.size:
      case LimitationType.duration:
        final allowed = currentUsage + requestedValue <= limitation.value!;
        return LimitCheckResult(
          name: limitationName,
          isAllowed: allowed,
          limit: limitation,
          currentUsage: currentUsage,
          requestedValue: requestedValue,
          reason: allowed ? null : 'Requested usage exceeds package limit.',
        );
    }
  }

  @override
  LimitCheckResult checkWithSnapshot({
    required TierPackage package,
    required UsageSnapshot usage,
    num requestedValue = 0,
  }) {
    return check(
      package: package,
      limitationName: usage.name,
      currentUsage: usage.currentValue,
      requestedValue: requestedValue,
    );
  }

  @override
  bool isFeatureEnabled({
    required TierPackage package,
    required String limitationName,
  }) {
    final limitation = package.limitationByName(limitationName);
    if (limitation == null) {
      return false;
    }

    if (limitation.isUnlimited) {
      return true;
    }

    return limitation.type == LimitationType.boolean && limitation.value == 1;
  }
}
