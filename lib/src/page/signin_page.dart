import 'package:flutter/material.dart';
import 'package:sso/sso.dart';

import '../identity.dart';

class SignInPage extends StatefulWidget {
  final Provider provider;
  final ThemeData theme;
  final Widget header;

  const SignInPage(this.provider, {Key key, this.theme, this.header})
      : super(key: key);

  @override
  State createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        // Context is changed, therefore,
        // we need to update identity's context
        Identity.of(context);

        // Initializing theme, header and actions
        Widget header = this.widget.header;
        List<Widget> actions = header == null ? [] : [header];
        actions.addAll(this.widget.provider.actions(context));

        return Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
