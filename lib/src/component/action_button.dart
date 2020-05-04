import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color color;
  final Color textColor;
  final ShapeBorder shape;
  final VoidCallback onPressed;

  ActionButton(
      {this.icon,
      this.text,
      this.color = Colors.white,
      this.textColor = Colors.black,
      this.shape,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: RaisedButton(
        color: color,
        onPressed: onPressed,
        padding: EdgeInsets.only(left: 8),
        shape: this.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 6, bottom: 6),
                  margin: EdgeInsets.only(left: 8, right: 24),
                  child: icon,
                ),
                Text(text, style: TextStyle(color: textColor, fontSize: 19))
              ],
            )),
      ),
    );
  }
}
