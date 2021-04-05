import 'package:flutter/material.dart';

class WildTextFormField extends StatelessWidget {
  final String title;
  final String initialValue;
  final String labelText;
  final Color color;
  final Icon icons;

  WildTextFormField(
      {this.color, this.title, this.initialValue, this.labelText, this.icons});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
          labelText: labelText,
          
          border: OutlineInputBorder(),
          suffixIcon: icons),
    );
  }
}
