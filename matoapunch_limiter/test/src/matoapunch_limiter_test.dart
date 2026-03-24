// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_limiter/matoapunch_limiter.dart';

void main() {
  group('MatoapunchLimiter', () {
    const limiter = MatoapunchLimiter();

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
      ],
    );

    test('can be instantiated', () {
      expect(MatoapunchLimiter(), isNotNull);
    });

    test('finds limitation by name', () {
      expect(
        limiter.limitationByName(
          package: package,
          limitationName: 'max_projects',
        ),
        package.limitations.first,
      );
    });

    test('finds limitation by code', () {
      expect(
        limiter.limitationByCode(
          package: package,
          limitationCode: 'max_projects',
        ),
        package.limitations.first,
      );
    });

    test('checks limitation usage', () {
      final result = limiter.check(
        package: package,
        limitationName: 'max_projects',
        currentUsage: 3,
        requestedValue: 1,
      );

      expect(result.isAllowed, isTrue);
      expect(result.limit, package.limitations.first);
    });

    test('checks limitation usage with snapshot', () {
      final result = limiter.checkWithSnapshot(
        package: package,
        usage: UsageSnapshot(
          name: 'max_projects',
          currentValue: 4,
        ),
        requestedValue: 1,
      );

      expect(result.isAllowed, isTrue);
      expect(result.currentUsage, 4);
    });

    test('checks whether feature is enabled', () {
      expect(
        limiter.isFeatureEnabled(
          package: package,
          limitationName: 'enable_export',
        ),
        isTrue,
      );
    });

    test('creates package from json and serializes it back', () {
      final json = package.toJson();
      final restored = limiter.packageFromJson(json);

      expect(restored, package);
      expect(limiter.packageToJson(restored), json);
    });
  });
}
