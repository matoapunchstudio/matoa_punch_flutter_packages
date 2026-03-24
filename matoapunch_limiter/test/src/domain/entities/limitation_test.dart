// Not required for test files.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_limiter/matoapunch_limiter.dart';

void main() {
  group('Limitation', () {
    test('can be instantiated with required fields', () {
      final limitation = Limitation(
        name: 'max_projects',
        displayName: 'Maximum Projects',
        type: LimitationType.count,
      );

      expect(limitation.name, 'max_projects');
      expect(limitation.displayName, 'Maximum Projects');
      expect(limitation.type, LimitationType.count);
      expect(limitation.description, '');
      expect(limitation.value, isNull);
    });

    test('can be instantiated with all fields', () {
      final limitation = Limitation(
        name: 'max_projects',
        displayName: 'Maximum Projects',
        type: LimitationType.count,
        description: 'Maximum number of projects allowed',
        value: 5,
      );

      expect(limitation.name, 'max_projects');
      expect(limitation.displayName, 'Maximum Projects');
      expect(limitation.description, 'Maximum number of projects allowed');
      expect(limitation.type, LimitationType.count);
      expect(limitation.value, 5);
    });

    test('isUnlimited returns true when value is null', () {
      final limitation = Limitation(
        name: 'max_projects',
        displayName: 'Maximum Projects',
        type: LimitationType.count,
      );

      expect(limitation.isUnlimited, isTrue);
    });

    test('isUnlimited returns false when value is set', () {
      final limitation = Limitation(
        name: 'max_projects',
        displayName: 'Maximum Projects',
        type: LimitationType.count,
        value: 10,
      );

      expect(limitation.isUnlimited, isFalse);
    });

    group('equality', () {
      test('two limitations with the same name are equal', () {
        final a = Limitation(
          name: 'max_projects',
          displayName: 'Maximum Projects',
          type: LimitationType.count,
          value: 5,
        );
        final b = Limitation(
          name: 'max_projects',
          displayName: 'Max Projects',
          type: LimitationType.count,
          value: 10,
        );

        expect(a, equals(b));
      });

      test('two limitations with different names are not equal', () {
        final a = Limitation(
          name: 'max_projects',
          displayName: 'Maximum Projects',
          type: LimitationType.count,
        );
        final b = Limitation(
          name: 'max_storage',
          displayName: 'Maximum Storage',
          type: LimitationType.size,
        );

        expect(a, isNot(equals(b)));
      });
    });

    group('fromJson', () {
      test('parses snake_case JSON', () {
        final json = <String, dynamic>{
          'name': 'max_projects',
          'display_name': 'Maximum Projects',
          'description': 'Maximum number of projects',
          'type': 'count',
          'value': 5,
        };

        final limitation = Limitation.fromJson(json);

        expect(limitation.name, 'max_projects');
        expect(limitation.displayName, 'Maximum Projects');
        expect(limitation.description, 'Maximum number of projects');
        expect(limitation.type, LimitationType.count);
        expect(limitation.value, 5);
      });

      test('parses camelCase displayName fallback', () {
        final json = <String, dynamic>{
          'name': 'enable_export',
          'displayName': 'Export Feature',
          'type': 'boolean',
          'value': 1,
        };

        final limitation = Limitation.fromJson(json);

        expect(limitation.displayName, 'Export Feature');
      });

      test('defaults description to empty string when missing', () {
        final json = <String, dynamic>{
          'name': 'max_projects',
          'display_name': 'Maximum Projects',
          'type': 'count',
          'value': 5,
        };

        final limitation = Limitation.fromJson(json);

        expect(limitation.description, '');
      });

      test('parses null value as unlimited', () {
        final json = <String, dynamic>{
          'name': 'max_projects',
          'display_name': 'Maximum Projects',
          'type': 'count',
          'value': null,
        };

        final limitation = Limitation.fromJson(json);

        expect(limitation.value, isNull);
        expect(limitation.isUnlimited, isTrue);
      });
    });

    group('toJson', () {
      test('produces snake_case JSON', () {
        final limitation = Limitation(
          name: 'trial_period',
          displayName: 'Trial Period',
          description: '30-day free trial',
          type: LimitationType.duration,
          value: 2592000,
        );

        final json = limitation.toJson();

        expect(json, <String, dynamic>{
          'name': 'trial_period',
          'display_name': 'Trial Period',
          'description': '30-day free trial',
          'type': 'duration',
          'value': 2592000,
        });
      });

      test('roundtrips through fromJson', () {
        final original = Limitation(
          name: 'max_storage',
          displayName: 'Maximum Storage',
          description: '500 MB storage limit',
          type: LimitationType.size,
          value: 524288000,
        );

        final restored = Limitation.fromJson(original.toJson());

        expect(restored.name, original.name);
        expect(restored.displayName, original.displayName);
        expect(restored.description, original.description);
        expect(restored.type, original.type);
        expect(restored.value, original.value);
      });
    });
  });

  group('LimitationType', () {
    test('has all expected values', () {
      expect(LimitationType.values, [
        LimitationType.count,
        LimitationType.boolean,
        LimitationType.duration,
        LimitationType.size,
      ]);
    });
  });
}
