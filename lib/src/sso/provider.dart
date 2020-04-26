import 'package:flutter/material.dart';

import 'authenticator.dart';
import 'mixin/will_convert_user.dart';
import 'mixin/will_notify.dart';
import 'notifier.dart';
import 'user.dart';
import 'user_converter.dart';

abstract class IdentityProvider with WillNotify, WillConvertUser {
  final List<Authenticator> _authenticators = List();

  /// Construct Provider
  ///
  /// Receives a list of authenticators as argument
  IdentityProvider(
      [List<Authenticator> authenticators = const [],
      Notifier notifier,
      UserConverter userConverter]) {
    this.notifier = notifier;
    this.userConverter = userConverter;
    for (Authenticator authenticator in authenticators) {
      this.use(authenticator);
    }
  }

  /// Register authenticator
  IdentityProvider use(Authenticator authenticator) {
    if (authenticator is WillNotify) {
      (authenticator as WillNotify).notifier = notifier;
    }
    if (authenticator is WillConvertUser) {
      (authenticator as WillConvertUser).userConverter = userConverter;
    }
    _authenticators.add(authenticator);
    return this;
  }

  /// Return list of action buttons
  List<Widget> actions(BuildContext context, [Widget divider]) {
    List<Widget> actions = [];
    for (Authenticator authenticator in _authenticators) {
      actions.add(authenticator.action(context));
      if (divider != null) {
        actions.add(divider);
      }
    }

    return actions;
  }

  /// Authenticate and return logged user
  Future<User> start();

  /// Stop session, log user out
  Future<void> stop();
}
