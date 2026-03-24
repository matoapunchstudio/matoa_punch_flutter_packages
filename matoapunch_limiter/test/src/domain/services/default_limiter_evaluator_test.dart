// Not required for test files.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_limiter/matoapunch_limiter.dart';

void main() {
  group('DefaultLimiterEvaluator', () {
    const evaluator = DefaultLimiterEvaluator();

    final package = TierPackage(
      id: 'pkg_pro',
      code: 'pro',
      name: 'pro',
      displayName: 'Pro',
      limitations: [
        Limitation(
          name: 'max_projects',
          displayName: 'Maximum Projects',
          type: LimitationType.count,
          value: 5,
        ),
        Limitation(
          name: 'enable_export',
          displayName: 'Export Feature',
          type: LimitationType.boolean,
          value: 1,
        ),
        Limitation(
          name: 'max_storage',
          displayName: 'Maximum Storage',
          type: LimitationType.size,
          value: 1000,
        ),
        Limitation(
          name: 'trial_period',
          displayName: 'Trial Period',
          type: LimitationType.duration,
          value: 30,
        ),
        Limitation(
          name: 'unlimited_api_calls',
          displayName: 'Unlimited API Calls',
          type: LimitationType.count,
        ),
      ],
    );

    test('allows count usage within the limit', () {
      final result = evaluator.check(
        package: package,
        limitationName: 'max_projects',
        currentUsage: 3,
        requestedValue: 2,
      );

      expect(result.isAllowed, isTrue);
      expect(result.reason, isNull);
    });

    test('denies count usage beyond the limit', () {
      final result = evaluator.check(
        package: package,
        limitationName: 'max_projects',
        currentUsage: 5,
        requestedValue: 1,
      );

      expect(result.isAllowed, isFalse);
      expect(result.reason, 'Requested usage exceeds package limit.');
    });

    test('allows enabled boolean feature', () {
      expect(
        evaluator.isFeatureEnabled(
          package: package,
          limitationName: 'enable_export',
        ),
        isTrue,
      );
    });

    test('treats unlimited limitation as allowed', () {
      final result = evaluator.check(
        package: package,
        limitationName: 'unlimited_api_calls',
        currentUsage: 100,
        requestedValue: 100,
      );

      expect(result.isAllowed, isTrue);
      expect(result.reason, isNull);
    });

    test('checks using usage snapshot', () {
      final result = evaluator.checkWithSnapshot(
        package: package,
        usage: UsageSnapshot(
          name: 'max_storage',
          currentValue: 750,
        ),
        requestedValue: 100,
      );

      expect(result.isAllowed, isTrue);
      expect(result.currentUsage, 750);
      expect(result.requestedValue, 100);
    });

    test('returns denied result when limitation is missing', () {
      final result = evaluator.check(
        package: package,
        limitationName: 'missing_limit',
      );

      expect(result.isAllowed, isFalse);
      expect(result.reason, 'Limitation not found in package.');
    });
  });
}
