import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  ActionButton(
      {this.icon,
      this.text,
      this.color = Colors.white,
      this.textColor = Colors.black,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: RaisedButton(
        color: color,
        onPressed: onPressed,
        padding: EdgeInsets.only(left: 8),
        child: Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 16),
                  child: icon,
                  color: Colors.white,
                ),
                Text(text.toUpperCase(), style: TextStyle(color: textColor))
              ],
            )),
      ),
    );
  }
}
