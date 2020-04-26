import 'package:flutter/material.dart';

import '../identity.dart';
import '../sso/provider.dart';

class SignInPage extends StatelessWidget {
  final IdentityProvider provider;
  final SignInPageSettings settings;

  const SignInPage(this.provider,
      {Key key, this.settings = const SignInPageSettings()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        // Context is changed, therefore,
        // we need to update identity's context
        Identity.instance.context = context;

        // Initializing theme, header and actions
        List<Widget> actions = settings.header == null ? [] : [settings.header];
        actions.addAll(provider.actions(context));

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

class SignInPageSettings {
  final Widget header;

  const SignInPageSettings({this.header});
}
