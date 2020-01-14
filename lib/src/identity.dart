import 'package:flutter/material.dart';
import 'package:sso/sso.dart';

import 'page/signin_page.dart';

class Identity {
  static Identity _instance;
  BuildContext _context;
  Provider _provider;
  WidgetBuilder _signInPageBuilder;
  WidgetBuilder _signInSuccessPageBuilder;
  User _user;

  User get user => _user;

  static Identity get instance => _instance;

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

  static Identity of(BuildContext context) {
    assert(context != null);
    if (_instance == null) {
      _instance = Identity();
    }
    _instance._context = context;

    return _instance;
  }

  /// Initialize Identity service
  ///
  /// Requires an Identity Provider and a WidgetBuilder which uses as
  /// a page to navigate to after log in successfully
  ///
  /// SignInPage can be customised using builder
  Future<void> init(Provider provider, WidgetBuilder success,
      {WidgetBuilder builder}) async {
    assert(provider != null);
    assert(success != null);
    _provider = provider;
    _signInPageBuilder = builder ?? (context) => SignInPage(provider);
    _signInSuccessPageBuilder = success;

    user = await provider.start();
  }

  void _clear() {
    _user = null;
    _provider.stop();
    Navigator.of(_context)
        .pushReplacement(MaterialPageRoute(builder: _signInPageBuilder));
  }

  void _handleUnverifiedEmail() {
    _showMessage('Please verify your email');
    Future.delayed(Duration(seconds: 2), () => _provider.stop());
  }

  void _handleSignInSuccess(User user) {
    _user = user;
    Navigator.popUntil(_context, (route) => route.isFirst);
    Navigator.pushReplacement(
        _context, MaterialPageRoute(builder: _signInSuccessPageBuilder));
  }

  void _showMessage(String message, [Map parameters]) =>
      _provider.notify(_context, message, parameters);

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
