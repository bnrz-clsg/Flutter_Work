import 'package:capstone_project/evac_user/evacuee_page.dart';
import 'package:capstone_project/screens/registerUserInfo.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ERouter extends StatefulWidget {
  @override
  _ERouterState createState() => _ERouterState();
}

class _ERouterState extends State<ERouter> {
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }



  var userValidator = FirebaseDatabase.instance
      .reference()
      .child('users/${currentFirebaseUser.uid}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: userValidator.onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            if (currentUserInfo.status == null) {
              return _registerUSer();
            } else if (currentUserInfo.status == "false") {
              return _verification();
            } else {
              return _verified();
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _verified() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(45)),
                    color: Colors.blue,
                    // textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.room,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Find available shelter',
                            style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 2,
                                fontFamily: 'Brand-Bold',
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EvacueePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ]);
  }

  Widget _registerUSer() {
    return Container(
      height: 300,
      child: Center(
        child: WildRaisedButton(
          color: Colors.white,
          title: 'Register hello tae',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterUserInfo()));
          },
        ),
      ),
    );
  }

  Widget _verification() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Text(
                  "Your Registration is on Process",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(75, 0, 75, 0),
                  child: Text(
                    'Your submitted registration is being reviewed by the admin wait for a moment',
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: LinearProgressIndicator(
                    minHeight: 15,
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          )
        ]);
  }
}
