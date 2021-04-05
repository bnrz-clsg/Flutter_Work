import 'package:capstone_project/screens/homescreen.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class GoogleSignin extends StatefulWidget {
  @override
  _GoogleSigninState createState() => _GoogleSigninState();
}

class _GoogleSigninState extends State<GoogleSignin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () {
          signInWithGoogle().then((result) {
            if (result != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        borderSide: BorderSide(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Center(
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/images/google_logo.png"),
                    height: 35.0),
                Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
