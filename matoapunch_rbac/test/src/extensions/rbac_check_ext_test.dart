// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_rbac/src/domain/abstracts/should_have_permission.dart';
import 'package:matoapunch_rbac/src/domain/entities/permission.dart';
import 'package:matoapunch_rbac/src/domain/entities/role.dart';
import 'package:matoapunch_rbac/src/extensions/rbac_check_ext.dart';

class _TestShouldHavePermission implements ShouldHavePermission {
  const _TestShouldHavePermission(this.permissions);

  @override
  final List<Permission> permissions;
}

void main() {
  group('ShouldHavePermissionRbacCheckExt', () {
    test('checks permissions from a permission-carrying object', () {
      final permissionable = _TestShouldHavePermission(
        const [
          Permission(name: 'user.read', displayName: 'Read User'),
          Permission(name: 'user.write', displayName: 'Write User'),
        ],
      );

      expect(
        permissionable.hasPermission(
          const Permission(name: 'user.read', displayName: 'Read User Again'),
        ),
        isTrue,
      );
      expect(permissionable.hasPermissionByName('user.write'), isTrue);
      expect(permissionable.hasPermissionByName('user.delete'), isFalse);
    });

    test(
      'checks whether a permission-carrying object grants any permission',
      () {
        final permissionable = _TestShouldHavePermission(
          const [
            Permission(name: 'user.read', displayName: 'Read User'),
          ],
        );

        expect(
          permissionable.hasAnyPermissions([
            const Permission(name: 'user.delete', displayName: 'Delete User'),
            const Permission(name: 'user.read', displayName: 'Read User'),
          ]),
          isTrue,
        );
        expect(
          permissionable.hasAnyPermissionsByName([
            'user.delete',
            'user.update',
          ]),
          isFalse,
        );
      },
    );
  });

  group('RoleRbacCheckExt', () {
    test('checks permissions from a single role', () {
      final role = Role(
        name: 'admin',
        displayName: 'Administrator',
        permissions: const [
          Permission(name: 'user.read', displayName: 'Read User'),
          Permission(name: 'user.write', displayName: 'Write User'),
        ],
      );

      expect(
        role.hasPermission(
          Permission(name: 'user.read', displayName: 'Read User Again'),
        ),
        isTrue,
      );
      expect(role.hasPermissionByName('user.write'), isTrue);
      expect(role.hasPermissionByName('user.delete'), isFalse);
    });

    test('checks whether a single role grants any permission', () {
      final role = Role(
        name: 'admin',
        displayName: 'Administrator',
        permissions: const [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      expect(
        role.hasAnyPermissions([
          Permission(name: 'user.delete', displayName: 'Delete User'),
          Permission(name: 'user.read', displayName: 'Read User'),
        ]),
        isTrue,
      );
      expect(
        role.hasAnyPermissionsByName(['user.delete', 'user.update']),
        isFalse,
      );
    });
  });

  group('ShouldHavePermissionListRbacCheckExt', () {
    test('checks permissions across multiple permission-carrying objects', () {
      final permissionables = <ShouldHavePermission>[
        const _TestShouldHavePermission([
          Permission(name: 'user.read', displayName: 'Read User'),
        ]),
        const _TestShouldHavePermission([
          Permission(name: 'user.write', displayName: 'Write User'),
        ]),
      ];

      expect(
        permissionables.hasPermission(
          const Permission(name: 'user.write', displayName: 'Write User Again'),
        ),
        isTrue,
      );
      expect(permissionables.hasPermissionByName('user.read'), isTrue);
      expect(permissionables.hasPermissionByName('user.delete'), isFalse);
    });

    test(
      'checks whether multiple permission-carrying objects '
      'grant any permission',
      () {
        final permissionables = <ShouldHavePermission>[
          const _TestShouldHavePermission([
            Permission(name: 'user.read', displayName: 'Read User'),
          ]),
          const _TestShouldHavePermission([
            Permission(name: 'user.write', displayName: 'Write User'),
          ]),
        ];

        expect(
          permissionables.hasAnyPermissions([
            const Permission(name: 'user.delete', displayName: 'Delete User'),
            const Permission(name: 'user.write', displayName: 'Write User'),
          ]),
          isTrue,
        );
        expect(
          permissionables.hasAnyPermissionsByName([
            'user.delete',
            'user.update',
          ]),
          isFalse,
        );
      },
    );
  });

  group('RoleListRbacCheckExt', () {
    test('checks permissions across multiple roles', () {
      final roles = [
        Role(
          name: 'admin',
          displayName: 'Administrator',
          permissions: const [
            Permission(name: 'user.read', displayName: 'Read User'),
          ],
        ),
        Role(
          name: 'editor',
          displayName: 'Editor',
          permissions: const [
            Permission(name: 'user.write', displayName: 'Write User'),
          ],
        ),
      ];

      expect(
        roles.hasPermission(
          Permission(name: 'user.write', displayName: 'Write User Again'),
        ),
        isTrue,
      );
      expect(roles.hasPermissionByName('user.read'), isTrue);
      expect(roles.hasPermissionByName('user.delete'), isFalse);
    });

    test('checks whether multiple roles grant any permission', () {
      final roles = [
        Role(
          name: 'admin',
          displayName: 'Administrator',
          permissions: const [
            Permission(name: 'user.read', displayName: 'Read User'),
          ],
        ),
        Role(
          name: 'editor',
          displayName: 'Editor',
          permissions: const [
            Permission(name: 'user.write', displayName: 'Write User'),
          ],
        ),
      ];

      expect(
        roles.hasAnyPermissions([
          Permission(name: 'user.delete', displayName: 'Delete User'),
          Permission(name: 'user.write', displayName: 'Write User'),
        ]),
        isTrue,
      );
      expect(
        roles.hasAnyPermissionsByName(['user.delete', 'user.update']),
        isFalse,
      );
    });
  });
}
