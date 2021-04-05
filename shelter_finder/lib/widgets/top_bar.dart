import 'package:capstone_project/screens/homescreen.dart';
import 'package:capstone_project/screens/profile.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class TopBar extends StatelessWidget {
  final Function onPressed;
  const TopBar({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        color: Color(0xFF303030),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF303030),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[900],
                                blurRadius: 1,
                                spreadRadius: 0.8,
                                offset: Offset(0.7, 0.7))
                          ]),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                        child: Image.asset(
                            'assets/images/baynihan_appbar_icon.png',
                            height: 30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile()),
                );
              },
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF303030),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[900],
                              blurRadius: 1,
                              spreadRadius: 0.8,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          (imageUrl != null) ? imageUrl : ' ',
                        ),
                        radius: 12,
                        backgroundColor: Color(0xFF303030),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.view_headline,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
