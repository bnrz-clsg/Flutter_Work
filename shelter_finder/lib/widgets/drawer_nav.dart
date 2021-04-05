import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              spreadRadius: 0.7,
              offset: Offset(0.9, 0.9)),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        child: Icon(
          Icons.arrow_forward_ios_sharp,
          color: Colors.grey[850],
          size: 30,
        ),
      ),
    );
  }
}
