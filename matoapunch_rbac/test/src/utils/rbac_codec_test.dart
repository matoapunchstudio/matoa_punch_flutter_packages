import 'dart:convert';

// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:matoapunch_rbac/src/domain/entities/permission.dart';
import 'package:matoapunch_rbac/src/utils/rbac_codec.dart';

void main() {
  group('RbacCodec', () {
    test('encodes and decodes permissions', () {
      final permissions = [
        Permission(name: 'user.read', displayName: 'Read User'),
        Permission(name: 'user.write', displayName: 'Write User'),
      ];

      final encoded = RbacCodec.encodePermissions(permissions);
      final decoded = RbacCodec.decodePermissions(encoded);

      expect(encoded, isNotEmpty);
      expect(decoded, hasLength(2));
      expect(decoded.first.name, 'user.read');
      expect(decoded.first.displayName, 'Read User');
      expect(decoded.last.name, 'user.write');
      expect(decoded.last.displayName, 'Write User');
    });

    test('encodes and decodes an empty permission list', () {
      final encoded = RbacCodec.encodePermissions(const []);
      final decoded = RbacCodec.decodePermissions(encoded);

      expect(decoded, isEmpty);
    });

    test('decodes legacy camelCase permission payloads', () {
      final encoded = base64Encode(
        utf8.encode(
          '[{"name":"user.read","displayName":"Read User"}]',
        ),
      );

      final decoded = RbacCodec.decodePermissions(encoded);

      expect(
        decoded,
        const [Permission(name: 'user.read', displayName: 'Read User')],
      );
    });
  });
}
