import 'package:matoapunch_rbac/src/domain/entities/permission.dart';

/// A contract for types that should expose a permission collection.
abstract class ShouldHavePermission {
  /// The permissions associated with this object.
  List<Permission> get permissions;
}
