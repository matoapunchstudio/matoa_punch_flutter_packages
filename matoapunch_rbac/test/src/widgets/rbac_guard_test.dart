import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_rbac/matoapunch_rbac.dart';
import 'package:matoapunch_rbac/src/domain/entities/permission.dart';
import 'package:matoapunch_rbac/src/domain/entities/role.dart';

void main() {
  group('RbacGuard', () {
    testWidgets('renders child when any permission matches', (tester) async {
      final rbac = MatoapunchRbac(
        permissions: const [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RbacGuard(
            rbac: rbac,
            permissions: const ['user.delete', 'user.read'],
            fallback: const Text('Denied'),
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsOneWidget);
      expect(find.text('Denied'), findsNothing);
    });

    testWidgets('renders fallback when no permission matches', (tester) async {
      final rbac = MatoapunchRbac(
        permissions: const [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RbacGuard(
            rbac: rbac,
            permissions: const ['user.delete'],
            fallback: const Text('Denied'),
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsNothing);
      expect(find.text('Denied'), findsOneWidget);
    });

    testWidgets('supports all-match evaluation', (tester) async {
      final rbac = MatoapunchRbac(
        permissions: const [
          Permission(name: 'user.read', displayName: 'Read User'),
          Permission(name: 'user.write', displayName: 'Write User'),
        ],
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RbacGuard(
            rbac: rbac,
            permissions: const ['user.read', 'user.write'],
            match: RbacGuardMatch.all,
            fallback: const Text('Denied'),
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsOneWidget);
      expect(find.text('Denied'), findsNothing);
    });

    testWidgets('uses an empty fallback by default', (tester) async {
      final rbac = MatoapunchRbac(
        permissions: const [
          Permission(name: 'user.read', displayName: 'Read User'),
        ],
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RbacGuard(
            rbac: rbac,
            permissions: const ['user.delete'],
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('can be created from raw permissions', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RbacGuard.fromPermissions(
            grantedPermissions: const [
              Permission(name: 'user.read', displayName: 'Read User'),
            ],
            permissions: const ['user.read'],
            fallback: const Text('Denied'),
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsOneWidget);
      expect(find.text('Denied'), findsNothing);
    });

    testWidgets('can be created from a role', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RbacGuard.fromRole(
            role: const Role(
              name: 'admin',
              displayName: 'Administrator',
              permissions: [
                Permission(name: 'user.read', displayName: 'Read User'),
              ],
            ),
            permissions: const ['user.read'],
            fallback: const Text('Denied'),
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsOneWidget);
      expect(find.text('Denied'), findsNothing);
    });

    testWidgets('can be created from multiple roles', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RbacGuard.fromRoles(
            roles: const [
              Role(
                name: 'admin',
                displayName: 'Administrator',
                permissions: [
                  Permission(name: 'user.read', displayName: 'Read User'),
                ],
              ),
              Role(
                name: 'editor',
                displayName: 'Editor',
                permissions: [
                  Permission(name: 'user.write', displayName: 'Write User'),
                ],
              ),
            ],
            permissions: const ['user.write'],
            fallback: const Text('Denied'),
            child: const Text('Allowed'),
          ),
        ),
      );

      expect(find.text('Allowed'), findsOneWidget);
      expect(find.text('Denied'), findsNothing);
    });
  });
}
