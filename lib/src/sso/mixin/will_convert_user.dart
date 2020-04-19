import '../user.dart';
import '../user_converter.dart';

mixin WillConvertUser {
  UserConverter userConverter;

  Future<User> convert(dynamic resource) =>
      this.userConverter.convert(resource);
}
