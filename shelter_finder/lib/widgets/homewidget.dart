import 'package:capstone_project/evac_user/evac_page.dart';
import 'package:capstone_project/shelter_user/shelter_page.dart';
import 'package:flutter/material.dart';
import 'bradDivider.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.black54, Color.fromRGBO(0, 41, 102, 1)])),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5.0),
            Text(
              'Nice to See you!',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Search for Open-House Shelter?',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Brand-Regular',
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            //Open shelter search
            RaisedButton(
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
                  MaterialPageRoute(builder: (context) => EvacUser()),
                );
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
                    borderRadius: new BorderRadius.circular(45)),
                color: Colors.greenAccent,
                // textColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShelterPage()));
                }),
          ],
        ),
      ),
    );
  }
}
