// Not required for test files.
// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_limiter/matoapunch_limiter.dart';

void main() {
  group('LimitationAware', () {
    final package = TierPackage(
      id: 'pkg_pro',
      code: 'pro',
      name: 'pro',
      displayName: 'Pro',
      limitations: [
        Limitation(
          name: 'enable_export',
          displayName: 'Export Feature',
          type: LimitationType.boolean,
          value: 1,
        ),
        Limitation(
          name: 'max_projects',
          displayName: 'Maximum Projects',
          type: LimitationType.count,
          value: 5,
        ),
      ],
    );

    testWidgets('renders child when feature flag is enabled', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LimitationAware(
            package: package,
            limitationName: 'enable_export',
            asFeatureFlag: true,
            child: Text('allowed'),
            fallback: Text('denied'),
          ),
        ),
      );

      expect(find.text('allowed'), findsOneWidget);
      expect(find.text('denied'), findsNothing);
    });

    testWidgets('renders child when usage is within the limit', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LimitationAware(
            package: package,
            limitationName: 'max_projects',
            currentUsage: 3,
            requestedValue: 1,
            child: Text('allowed'),
            fallback: Text('denied'),
          ),
        ),
      );

      expect(find.text('allowed'), findsOneWidget);
      expect(find.text('denied'), findsNothing);
    });

    testWidgets('renders fallback when usage exceeds the limit', (
      tester,
    ) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LimitationAware(
            package: package,
            limitationName: 'max_projects',
            currentUsage: 5,
            requestedValue: 1,
            child: Text('allowed'),
            fallback: Text('denied'),
          ),
        ),
      );

      expect(find.text('allowed'), findsNothing);
      expect(find.text('denied'), findsOneWidget);
    });
  });
}
