import 'package:flutter/widgets.dart';

import '../notifier.dart';

mixin WillNotify {
  Notifier notifier = Notifier();

  void notify(BuildContext context, String message, [Map parameters]) =>
      this.notifier.notify(context, message, parameters);
}
