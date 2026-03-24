import 'package:flutter/widgets.dart';
import 'package:matoapunch_limiter/src/domain/entities/tier_package.dart';
import 'package:matoapunch_limiter/src/matoapunch_limiter.dart';

/// Conditionally renders a widget based on a package limitation.
class LimitationAware extends StatelessWidget {
  /// Creates a limitation-aware widget wrapper.
  const LimitationAware({
    required this.package,
    required this.limitationName,
    required this.child,
    super.key,
    this.fallback = const SizedBox.shrink(),
    this.limiter = const MatoapunchLimiter(),
    this.currentUsage = 0,
    this.requestedValue = 0,
    this.asFeatureFlag = false,
  });

  /// The package whose limitations are evaluated.
  final TierPackage package;

  /// The limitation key to evaluate.
  final String limitationName;

  /// The widget to render when the limitation allows it.
  final Widget child;

  /// The widget to render when the limitation denies it.
  final Widget fallback;

  /// The limiter entry point used to evaluate access.
  final MatoapunchLimiter limiter;

  /// Current usage value for numeric limitations.
  final num currentUsage;

  /// Incremental requested usage value for numeric limitations.
  final num requestedValue;

  /// Whether the limitation should be evaluated as a feature flag.
  ///
  /// When `true`, the widget uses [MatoapunchLimiter.isFeatureEnabled].
  /// Otherwise it uses [MatoapunchLimiter.check].
  final bool asFeatureFlag;

  @override
  Widget build(BuildContext context) {
    final isAllowed = asFeatureFlag
        ? limiter.isFeatureEnabled(
            package: package,
            limitationName: limitationName,
          )
        : limiter
            .check(
              package: package,
              limitationName: limitationName,
              currentUsage: currentUsage,
              requestedValue: requestedValue,
            )
            .isAllowed;

    return isAllowed ? child : fallback;
  }
}
