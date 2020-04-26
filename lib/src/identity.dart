import 'package:emitter/emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:identity/src/event/user_changed_event.dart';

import 'page/signin_page.dart';
import 'sso/provider.dart';
import 'sso/user.dart';

class Identity {
  static const EVENT_USER_CHANGED = "identity.user.changed";
  final IdentityProvider provider;
  BuildContext context;
  WidgetBuilder _authenticatedPageBuilder;
  WidgetBuilder _signInPageBuilder;
  bool _popOnSuccess;

  static Identity instance;
  User _user;

  Identity(this.provider, {EventListener onUserChanged}) {
    if (onUserChanged != null) {
      EventEmitter.instance.on(EVENT_USER_CHANGED, onUserChanged);
    }
  }

  User get user => _user;

  set user(User user) {
    EventEmitter.instance.emit(EVENT_USER_CHANGED, UserChangedEvent(user));
    if (context == null) {
      _user = user;
      return;
    }
    if (user == null) {
      _clear();
    } else if (user.isVerified == false) {
      _handleUnverifiedEmail();
    } else {
      _handleSignInSuccess(user);
    }
  }

  bool get isAuthenticated =>
      user != null &&
      user.token != null &&
      user.token.isNotEmpty &&
      user.expiredAt != null &&
      user.expiredAt.isAfter(DateTime.now());

  static Identity of(BuildContext context) {
    assert(context != null);
    instance.context = context;

    return instance;
  }

  /// Run Identity service
  ///
  /// Requires a WidgetBuilder which uses as
  /// a page to navigate to after log in successfully
  ///
  /// SignInPage can be customised using signInPageBuilder
  Future<void> run(BuildContext context, WidgetBuilder authenticatedPageBuilder,
      {WidgetBuilder signInPageBuilder, bool popOnSuccess = true}) async {
    this.context = context;
    _authenticatedPageBuilder = authenticatedPageBuilder;
    _signInPageBuilder = signInPageBuilder ?? (context) => SignInPage(provider);
    _popOnSuccess = popOnSuccess;

    user = await provider.start();
  }

  void _clear() {
    _user = null;
    provider.stop();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: _signInPageBuilder));
  }

  void _handleUnverifiedEmail() {
    _showMessage('Please verify your email');
    Future.delayed(Duration(seconds: 2), () => provider.stop());
  }

  void _handleSignInSuccess(User user) {
    _user = user;
    if (_popOnSuccess) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: _authenticatedPageBuilder));
  }

  void _showMessage(String message, [Map parameters]) =>
      provider.notify(context, message, parameters);

  /// Helper to handle error
  ///
  /// It will show a snack bar if possible
  /// otherwise it logs error to console
  void error(dynamic error) {
    if (error == null) {
      return;
    }
    if (context != null) {
      String message;
      if (error is String) {
        message = error;
      } else if (error is PlatformException) {
        message = error.message;
      } else {
        message = error.toString();
      }
      _showMessage(message, {"error": error});
    } else {
      print(error);
    }
  }
}
