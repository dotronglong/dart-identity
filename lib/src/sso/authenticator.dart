import 'package:flutter/widgets.dart';

abstract class Authenticator {
  /// Returns a widget builder for action button
  WidgetBuilder get action;

  /// Authenticate user
  Future<void> authenticate(BuildContext context, [Map parameters]);
}
