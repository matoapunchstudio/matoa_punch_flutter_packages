// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_rbac/matoapunch_rbac.dart';

void main() {
  group('MatoapunchRbac', () {
    test('can be instantiated', () {
      expect(MatoapunchRbac(), isNotNull);
    });

    test('checks permission by instance using permission name', () {
      final rbac = MatoapunchRbac(
        permissions: [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      expect(
        rbac.hasPermission(
          Permission(name: 'user.read', displayName: 'Read User Again'),
        ),
        isTrue,
      );
    });

    test('checks permission by name', () {
      final rbac = MatoapunchRbac(
        permissions: [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      expect(rbac.hasPermissionByName('user.read'), isTrue);
      expect(rbac.hasPermissionByName('user.write'), isFalse);
    });

    test('checks whether any permission exists', () {
      final rbac = MatoapunchRbac(
        permissions: [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      expect(
        rbac.hasAnyPermissions([
          Permission(name: 'user.write', displayName: 'Write User'),
          Permission(name: 'user.read', displayName: 'Read User'),
        ]),
        isTrue,
      );
    });

    test('checks whether any permission name exists', () {
      final rbac = MatoapunchRbac(
        permissions: [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      expect(
        rbac.hasAnyPermissionsByName(['user.write', 'user.read']),
        isTrue,
      );
      expect(
        rbac.hasAnyPermissionsByName(['user.write', 'user.delete']),
        isFalse,
      );
    });

    test('exposes permissions as an immutable list', () {
      final rbac = MatoapunchRbac(
        permissions: [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      expect(rbac.permissions, hasLength(1));
      expect(
        () => rbac.permissions.add(
          const Permission(name: 'user.write', displayName: 'Write User'),
        ),
        throwsUnsupportedError,
      );
    });

    test('encodes and decodes permissions through factories', () {
      final rbac = MatoapunchRbac(
        permissions: [
          Permission(name: 'user.read', displayName: 'Read User'),
          Permission(name: 'user.write', displayName: 'Write User'),
        ],
      );

      final encoded = rbac.encodePermissions();
      final decoded = MatoapunchRbac.fromEncodedPermissions(encoded);

      expect(decoded.permissions, rbac.permissions);
    });

    test('creates RBAC state from role permissions', () {
      final role = Role(
        name: 'admin',
        displayName: 'Administrator',
        permissions: const [
          Permission(name: 'user.read', displayName: 'Read User'),
          Permission(name: 'user.write', displayName: 'Write User'),
        ],
      );

      final rbac = MatoapunchRbac.fromRole(role);

      expect(rbac.permissions, role.permissions);
      expect(rbac.hasPermissionByName('user.read'), isTrue);
      expect(rbac.hasPermissionByName('user.write'), isTrue);
      expect(rbac.hasPermissionByName('user.delete'), isFalse);
    });

    test('creates RBAC state from combined role permissions', () {
      final roles = [
        const Role(
          name: 'admin',
          displayName: 'Administrator',
          permissions: [
            Permission(name: 'user.read', displayName: 'Read User'),
          ],
        ),
        const Role(
          name: 'editor',
          displayName: 'Editor',
          permissions: [
            Permission(name: 'user.write', displayName: 'Write User'),
          ],
        ),
      ];

      final rbac = MatoapunchRbac.fromAnyRole(roles);

      expect(rbac.hasPermissionByName('user.read'), isTrue);
      expect(rbac.hasPermissionByName('user.write'), isTrue);
      expect(rbac.hasPermissionByName('user.delete'), isFalse);
    });

    test('creates empty RBAC state from empty role list', () {
      final rbac = MatoapunchRbac.fromAnyRole(const []);

      expect(rbac.permissions, isEmpty);
      expect(rbac.hasPermissionByName('user.read'), isFalse);
    });
  });
}
