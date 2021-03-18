import 'package:flutter/material.dart';

class TextFieldCallBack extends StatelessWidget {
  final String hint;
  final String label;
  final TextInputType textInputType;
  final bool obscure;
  final TextCapitalization textCap;

  TextFieldCallBack(
      {this.label, this.hint, this.textInputType, this.obscure, this.textCap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2.5, 0, 2.5),
      child: TextField(
        textCapitalization: textCap,
        obscureText: obscure,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: OutlineInputBorder(gapPadding: 1),
          hintText: hint,
          labelText: label,
        ),
      ),
    );
  }
}
