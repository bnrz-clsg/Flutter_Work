// import 'package:capstone_project/dataprovider/appdata.dart';
import 'package:capstone_project/screens/destinationpage.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'bradDivider.dart';

class ShleterSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                spreadRadius: 0.8,
                offset: Offset(0.7, 0.7))
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Nice to See you!',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'Search for Open-House Shelter?',
              style: TextStyle(fontSize: 20.0, fontFamily: 'Brand-Bold'),
            ),
            SizedBox(
              height: 20,
            ),
            //search box
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DestinationPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.5),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('Search Destination'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Row(
              children: <Widget>[
                Icon(
                  OMIcons.home,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        // (Provider.of<AppData>(context).pickupAddress != null)
                        //   ? Provider.of<AppData>(context).pickupAddress.placeName
                        //   :
                        'Add Current Location'),
                    SizedBox(height: 3),
                    Text(
                      'Your residential address',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            BrandDivider(),
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                Icon(
                  OMIcons.work,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Add Work'),
                    SizedBox(height: 3),
                    Text(
                      'Your office address',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
