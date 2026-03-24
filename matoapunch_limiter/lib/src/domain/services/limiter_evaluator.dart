import 'package:matoapunch_limiter/src/domain/entities/limit_check_result.dart';
import 'package:matoapunch_limiter/src/domain/entities/tier_package.dart';
import 'package:matoapunch_limiter/src/domain/entities/usage_snapshot.dart';

/// Evaluates whether usage is allowed under a package limitation.
abstract class LimiterEvaluator {
  /// Checks a requested usage change against a package limitation.
  LimitCheckResult check({
    required TierPackage package,
    required String limitationName,
    num currentUsage = 0,
    num requestedValue = 0,
  });

  /// Returns whether a boolean-style feature flag is enabled.
  bool isFeatureEnabled({
    required TierPackage package,
    required String limitationName,
  });

  /// Checks a limitation using a usage snapshot.
  LimitCheckResult checkWithSnapshot({
    required TierPackage package,
    required UsageSnapshot usage,
    num requestedValue = 0,
  });
}
