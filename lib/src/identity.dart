import 'package:flutter/material.dart';
import 'package:identity/src/page/signin_page.dart';
import 'package:sso/sso.dart';

class Identity {
  static Identity _instance;
  BuildContext _context;
  Provider _provider;
  WidgetBuilder _signInPageBuilder;
  WidgetBuilder _signInSuccessPageBuilder;
  User _user;

  User get user => _user;
  BuildContext get context => _context;

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
  /// SignInPage can be customised using theme, header and divider
  Future<void> init(Provider provider, WidgetBuilder success,
      {ThemeData theme, Widget header, Widget divider}) async {
    assert(provider != null);
    assert(success != null);
    _provider = provider;
    _signInPageBuilder = (context) =>
        SignInPage(provider, theme: theme, header: header, divider: divider);
    _signInSuccessPageBuilder = success;

    user = await provider.start();
  }

  void _clear() {
    _user = null;
    Navigator.of(_context)
        .pushReplacement(MaterialPageRoute(builder: _signInPageBuilder));
  }

  void _handleUnverifiedEmail() {
    Scaffold.of(_context)
        .showSnackBar(SnackBar(content: Text('Please verify your email')));
    Future.delayed(Duration(seconds: 2), () => _provider.stop());
  }

  void _handleSignInSuccess(User user) {
    _user = user;
    Navigator.of(_context)
        .pushReplacement(MaterialPageRoute(builder: _signInSuccessPageBuilder));
  }
}
