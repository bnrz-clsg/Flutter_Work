import 'package:capstone_project/evac_user/evac_page.dart';
import 'package:capstone_project/screens/registerUserInfo.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/shelter_user/shelter_page.dart';
import 'package:capstone_project/widgets/bradDivider.dart';
import 'package:capstone_project/widgets/drawer_list.dart';

import 'package:capstone_project/widgets/home_button.dart';
import 'package:capstone_project/widgets/top_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  void showSnackBar(String title) {
    final snackBar = SnackBar(
        backgroundColor: Colors.deepOrange,
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, wordSpacing: 2),
        ));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  var userValidator = FirebaseDatabase.instance
      .reference()
      .child('users/${currentFirebaseUser.uid}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        drawer: DrawerList(),
        body: StreamBuilder(
            stream: userValidator.onValue,
            builder: (context, snapshot) {
              return Stack(children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              ExactAssetImage('assets/images/background.jpg'),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
                //navigation drawer
                // Positioned(
                //   top: 120,
                //   left: 20,
                //   child: GestureDetector(
                //       onTap: () {
                //         _scaffoldkey.currentState.openDrawer();
                //       },
                //       child: NavigationDrawer()),
                // ),
                // baynihan logo
                Positioned(
                    top: 120,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                          radius: 50,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo_icon_final.png',
                              // height: 150,
                              // width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    )),
                //SearchSheet
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 350,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.black54,
                                Color.fromRGBO(0, 41, 102, 1)
                              ])),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            Text(
                              'Nice to See you!',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Search for Open-House Shelter?',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Brand-Regular',
                                  color: Colors.white,
                                  ),
                            ),
                            SizedBox(height: 10),
                            //Open shelter search
                            RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(45)),
                              color: Colors.blue,
                              // textColor: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 0, 15),
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
                                if (snapshot.data.snapshot.value == null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterUserInfo()));
                                } else if (currentUserInfo.status == "true") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EvacUser()));
                                } else {
                                  showSnackBar(
                                      'Your Registration is on process, Wait for awhile!');
                                }
                              },
                            ),
                            SizedBox(height: 20),

                            BrandDivider(),
                            SizedBox(
                              height: 17,
                            ),
                            //Shelter provider button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5),
                                Text(
                                  'Want to Open a Shelter?',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Brand-Regular',
                                      color: Colors.white),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                            RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(45)),
                                color: Colors.greenAccent,
                                // textColor: Colors.white,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.roofing,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Create my Shelter',
                                        style: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 2,
                                            fontFamily: 'Brand-Bold',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  if (snapshot.data.snapshot.value == null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterUserInfo()));
                                  } else if (currentUserInfo.status == "true") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShelterPage()));
                                  } else {
                                    showSnackBar(
                                        'Your Registration is on process, Wait for awhile!');
                                  }
                                }),
                          ],
                        ),
                      ),
                    )),
                TopBar(onPressed: () {
                  _scaffoldkey.currentState.openDrawer();
                }),
                //middle button "search nearest evacuation"
                Button(),
              ]);
            }));
  }
}
