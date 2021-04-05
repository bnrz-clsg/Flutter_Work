import 'package:flutter/material.dart';

class WildActiveOutlineButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;
  final TextStyle style;

  WildActiveOutlineButton({this.title, this.onPressed, this.color, this.style});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: color, style: BorderStyle.solid, width: 3),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(25.0),
      ),
      onPressed: onPressed,
      color: color,
      child: Container(
        height: 50.0,
        width: 200,
        child: Center(
          child: Text(title, style: style),
        ),
      ),
    );
  }
}
