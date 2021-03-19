import 'package:flutter/material.dart';

class WildRaisedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;
  final TextStyle style;

  WildRaisedButton({this.title, this.onPressed, this.color, this.style});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(45)),
      color: color,
      // textColor: Colors.white,
      child: Container(
        height: 50.0,
        width: 200,
        child: Center(
          child: Text(
            title,
            style: style,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
