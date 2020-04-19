import 'package:flutter/material.dart';

import 'page/signin_page.dart';
import 'sso/provider.dart';
import 'sso/user.dart';

class Identity {
  final Provider _provider;
  final WidgetBuilder _authenticatedPageBuilder;

  static Identity _instance;
  WidgetBuilder _signInPageBuilder;
  User _user;
  BuildContext _context;

  Identity(
      {@required Provider provider,
      @required WidgetBuilder authenticatedPageBuilder})
      : _provider = provider,
        _authenticatedPageBuilder = authenticatedPageBuilder;

  static Identity get instance {
    assert(_instance != null);
    return _instance;
  }

  BuildContext get context => _context;

  set context(BuildContext context) {
    assert(context != null);
    _context = context;
  }

  User get user => _user;

  set user(User user) {
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

  /// Initialize Identity service
  ///
  /// Requires an Identity Provider and a WidgetBuilder which uses as
  /// a page to navigate to after log in successfully
  ///
  /// SignInPage can be customised using builder
  Future<void> init(BuildContext context,
      {WidgetBuilder signInPageBuilder}) async {
    this.context = context;
    _signInPageBuilder =
        signInPageBuilder ?? (context) => SignInPage(_provider);

    user = await _provider.start();
  }

  void _clear() {
    _user = null;
    _provider.stop();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: _signInPageBuilder));
  }

  void _handleUnverifiedEmail() {
    _showMessage('Please verify your email');
    Future.delayed(Duration(seconds: 2), () => _provider.stop());
  }

  void _handleSignInSuccess(User user) {
    _user = user;
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        _context, MaterialPageRoute(builder: _authenticatedPageBuilder));
  }

  void _showMessage(String message, [Map parameters]) =>
      _provider.notify(context, message, parameters);

  /// Helper to handle error
  ///
  /// It will show a snack bar if possible
  /// otherwise it logs error to console
  void error(dynamic error) {
    if (error == null) {
      return;
    }
    if (_context != null) {
      _showMessage(
          error is String ? error : error.toString(), {"error": error});
    } else {
      print(error);
    }
  }
}
