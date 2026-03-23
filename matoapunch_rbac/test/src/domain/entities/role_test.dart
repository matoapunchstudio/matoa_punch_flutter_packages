// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_rbac/src/domain/entities/permission.dart';
import 'package:matoapunch_rbac/src/domain/entities/role.dart';

void main() {
  group('Role', () {
    test('supports value equality', () {
      expect(
        const Role(name: 'admin', displayName: 'Administrator'),
        const Role(name: 'admin', displayName: 'Administrator'),
      );
    });

    test('serializes to json', () {
      final role = Role(
        name: 'admin',
        displayName: 'Administrator',
        permissions: const [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      expect(role.toJson(), const <String, dynamic>{
        'name': 'admin',
        'display_name': 'Administrator',
        'permissions': [
          {
            'name': 'user.read',
            'display_name': 'Read User',
          },
        ],
      });
    });

    test('deserializes from json', () {
      final role = Role.fromJson(const <String, dynamic>{
        'name': 'admin',
        'display_name': 'Administrator',
        'permissions': [
          {
            'name': 'user.read',
            'display_name': 'Read User',
          },
        ],
      });

      expect(role.name, 'admin');
      expect(role.displayName, 'Administrator');
      expect(
        role.permissions,
        const [Permission(name: 'user.read', displayName: 'Read User')],
      );
    });

    test('deserializes from legacy camelCase json', () {
      final role = Role.fromJson(const <String, dynamic>{
        'name': 'admin',
        'displayName': 'Administrator',
        'permissions': [
          {
            'name': 'user.read',
            'displayName': 'Read User',
          },
        ],
      });

      expect(role.name, 'admin');
      expect(role.displayName, 'Administrator');
      expect(
        role.permissions,
        const [Permission(name: 'user.read', displayName: 'Read User')],
      );
    });
  });
}
