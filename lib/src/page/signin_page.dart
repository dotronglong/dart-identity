import 'package:flutter/material.dart';
import 'package:sso/sso.dart';

class SignInPage extends StatefulWidget {
  final Provider provider;
  final ThemeData theme;
  final Widget header;
  final Widget divider;

  const SignInPage(this.provider,
      {Key key, this.theme, this.header, this.divider})
      : super(key: key);

  @override
  State createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = this.widget.theme ?? Theme.of(context);
    Widget header = this.widget.header ?? _header();
    List<Widget> actions = [header];
    actions.addAll(this.widget.provider.actions(context));

    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
          color: theme.primaryColor,
          padding: EdgeInsets.only(left: 16, right: 16, top: 24),
          height: double.infinity,
          child: Center(
            child: Card(
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
          ),
        );
      }),
    );
  }

  Widget _header() {
    return Container();
  }
}
