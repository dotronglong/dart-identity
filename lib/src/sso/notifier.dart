import 'package:flutter/widgets.dart';

class Notifier {
  /// Allow to notify user
  ///
  /// For instance, show an error, message or an email
  void notify(BuildContext context, String message, [Map parameters]) =>
      print(message);
}
