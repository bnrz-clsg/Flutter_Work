import 'package:capstone_project/screens/homescreen.dart';
import 'package:capstone_project/screens/login_page.dart';
import 'package:capstone_project/screens/profile.dart';
import 'package:capstone_project/tester/e_router.dart';
import 'package:capstone_project/tester/shelterterster.dart';
import 'package:capstone_project/tester/tester.dart';
import 'package:capstone_project/tester/testerProfile.dart';
import 'package:capstone_project/widgets/bradDivider.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../auth.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.black54, Color.fromRGBO(0, 41, 102, 1)])),
          child: ListView(
            // padding: EdgeInsets.all(20),
            children: <Widget>[
              Container(
                  height: 190,
                  child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF303030),
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[900],
                                          blurRadius: 2,
                                          spreadRadius: 0.8,
                                          offset: Offset(0.7, 0.7))
                                    ]),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyProfile()),
                                    );
                                  },
                                  child: (imageUrl != null)
                                      ? CircleAvatar(
                                          radius: 48,
                                          backgroundColor: Colors.transparent,
                                          child: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(imageUrl),
                                            radius: 45,
                                            backgroundColor: Colors.transparent,
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/user_icon.png',
                                          height: 70,
                                          width: 70,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text((gusername != null) ? gusername : ' ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 3),
                            Text((email != null) ? email : ' ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ))
                          ]))),
              BrandDivider(),
              SizedBox(height: 10),
              ListTile(
                  leading: Icon(Icons.home, color: Colors.blue),
                  title: Text(
                    'Home',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }),
              ListTile(
                  leading: Icon(OMIcons.accountCircle, color: Colors.grey),
                  title: Text(
                    'My Profile',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfile()),
                    );
                  }),
              ListTile(
                leading: Icon(OMIcons.personPin, color: Colors.grey),
                title: Text(
                  'My shelter',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(OMIcons.album, color: Colors.grey),
                title: Text(
                  'About',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TesterClass()),
                  );
                },
              ),
              ListTile(
                leading: Icon(OMIcons.album, color: Colors.grey),
                title: Text(
                  'TESTER - Evacuee',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ERouter()),
                  );
                },
              ),
              ListTile(
                leading: Icon(OMIcons.album, color: Colors.grey),
                title: Text(
                  'TESTER - Shelter',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShelterTester()),
                  );
                },
              ),
              ListTile(
                leading: Icon(OMIcons.album, color: Colors.grey),
                title: Text(
                  'PAGE TESTER',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TesterTest()),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              BrandDivider(),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  return Alert(
                      context: context,
                      title: "Sign out account?",
                      content: Column(
                        children: <Widget>[
                          SizedBox(height: 15.0),
                          SizedBox(height: 10.0),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          color: Colors.red,
                          onPressed: () {
                            signOutEmail();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return LoginPage();
                            }), ModalRoute.withName('/'));
                          },
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ]).show();
                },
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(fontSize: 20.0, color: Colors.grey[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
