import 'package:capstone_project/screens/homescreen.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ShelterInfo extends StatefulWidget {
  static const String id = 'shelterinfo';

  @override
  _ShelterInfoState createState() => _ShelterInfoState();
}

class _ShelterInfoState extends State<ShelterInfo> {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  DatabaseReference shelterRef;

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(title,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 15)));
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  var shelterStreetController = TextEditingController();
  var shelterBrgyController = TextEditingController();
  var shelterCityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/logo_icon_final.png'),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
              child: Column(
                children: [
                  Text(
                    'Enter Shelter details',
                    style: TextStyle(fontFamily: 'Brand_Bold', fontSize: 22),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: shelterStreetController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'House no#, Street address, House address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                      controller: shelterBrgyController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'City Address',
                        border: OutlineInputBorder(),
                      )),
                  SizedBox(height: 10),
                  TextField(
                    controller: shelterCityController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Zip Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  WildRaisedButton(
                    // color: Colors.grey,
                    onPressed: () {
                      if (shelterBrgyController.text.length < 5) {
                        showSnackBar('Please provide a valid address');
                        return;
                      }
                      if (shelterCityController.text.length < 3) {
                        showSnackBar('Plese provide valid city address');
                        return;
                      }
                      if (shelterStreetController.text.length < 3) {
                        showSnackBar('Please provide valid address');
                        return;
                      }
                      updateProfile();
                    },
                    title: 'Create Shelter',
                    style: TextStyle(
                        fontFamily: 'Brand-regular',
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateProfile() {
    String id = currentFirebaseUser.uid;
// <Firebase>
    shelterRef = FirebaseDatabase.instance.reference().child('shelters/$id');

// <Firestore>
    DocumentReference _shelterReg =
        FirebaseFirestore.instance.collection('shelter').doc('$id');

    Map<String, dynamic> sheltermap = {
      'addrs_3': shelterBrgyController.text,
      'addrs_2': shelterCityController.text,
      'addrs_1': shelterStreetController.text,
    };

    Map<String, dynamic> map = {
      'verified': 'false',
      'activity': 'waiting',
      'user_id': '$id',
      'created_at': DateTime.now().toString(),
      'username': currentUserInfo.fullName,
      'email': currentUserInfo.email,
      'phone': currentUserInfo.phone,
      'shelter_details': sheltermap,
    };
    shelterRef.set(map); //<send to firebase realtime database
    _shelterReg.set(map); //<send to firebstore>

    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
  }
}
