// Not required for test files.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_limiter/matoapunch_limiter.dart';

void main() {
  group('UsageSnapshot', () {
    test('serializes to json', () {
      const snapshot = UsageSnapshot(
        name: 'max_projects',
        currentValue: 3,
      );

      expect(snapshot.toJson(), {
        'name': 'max_projects',
        'current_value': 3,
      });
    });

    test('parses from json', () {
      final snapshot = UsageSnapshot.fromJson({
        'name': 'max_storage',
        'current_value': 1024,
      });

      expect(snapshot.name, 'max_storage');
      expect(snapshot.currentValue, 1024);
    });
  });
}
