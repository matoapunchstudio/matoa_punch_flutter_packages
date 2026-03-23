// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_rbac/src/domain/entities/permission.dart';

void main() {
  group('Permission', () {
    test('supports value equality', () {
      expect(
        const Permission(name: 'user.read', displayName: 'Read User'),
        const Permission(name: 'user.read', displayName: 'Read User'),
      );
    });

    test('serializes to json', () {
      final permission = Permission(
        name: 'user.read',
        displayName: 'Read User',
      );

      expect(permission.toJson(), const <String, dynamic>{
        'name': 'user.read',
        'display_name': 'Read User',
      });
    });

    test('deserializes from json', () {
      final permission = Permission.fromJson(const <String, dynamic>{
        'name': 'user.read',
        'display_name': 'Read User',
      });

      expect(permission.name, 'user.read');
      expect(permission.displayName, 'Read User');
    });

    test('deserializes from legacy camelCase json', () {
      final permission = Permission.fromJson(const <String, dynamic>{
        'name': 'user.read',
        'displayName': 'Read User',
      });

      expect(permission.name, 'user.read');
      expect(permission.displayName, 'Read User');
    });
  });
}
