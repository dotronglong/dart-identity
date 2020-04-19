import 'user.dart';

abstract class UserConverter {
  /// Convert a resource into SSO User
  ///
  /// Returns an instance of User
  Future<User> convert(dynamic resource) =>
      throw UnimplementedError("convert is not implemented");
}
