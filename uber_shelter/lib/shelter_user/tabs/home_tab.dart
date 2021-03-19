import 'dart:async';
// import 'dart:js';
import 'package:capstone_project/models/shelters.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/services/pushnotificationservice.dart';
import 'package:capstone_project/widgets/brandcolor.dart';
import 'package:capstone_project/widgets/confirmSheet.dart';
import 'package:capstone_project/widgets/wildoutlinebutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

// <On press change button>
  String availabilityTitle = 'GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;
  bool isAvailable = false;
//<end>

// <Show Current postion on the map>
  void setupPositionLocator() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 12);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address =
        await HelperMethods.findCordinateAddress(position, context);
    print(address);
  }

  void getCurrentShelterInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    DatabaseReference shelterRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}');
    shelterRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        currentSheltersInfo = Shelters.fromSnapshot(snapshot);
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();
  }

  @override
  void initState() {
    super.initState();
    getCurrentShelterInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // <Map: get Current Location>
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexOne,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;

              setupPositionLocator();
            },
          ),
        ),
        Container(
          height: 155,
          width: double.infinity,
          color: Color.fromRGBO(14, 21, 38, .85),
        ),
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WildOutlineButton(
                color: availabilityColor,
                title: availabilityTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
                onPressed: () {
                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheets(
                            title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                            subtitle: (!isAvailable)
                                ? 'You are about to become available to accept SHELTER requests'
                                : 'You are about to stop receiving SHELTER requests',
                            onPress: () {
                              if (!isAvailable) {
                                goOnline();
                                getUpdate();
                                Navigator.pop(context);

                                setState(() {
                                  availabilityColor = BrandColors.colorAccent;
                                  availabilityTitle = 'GO OFFLINE';
                                  isAvailable = true;
                                });
                              } else {
                                goOffline();
                                Navigator.pop(context);
                                setState(() {
                                  availabilityColor = BrandColors.colorOrange;
                                  availabilityTitle = 'GO ONLINE';
                                  isAvailable = false;
                                });
                              }
                            },
                          ));
                },
              ),
            ],
          ),
        )
      ],
    );
  }

//< go online and push location address to firebase database>
  void goOnline() {
    // <firebase query push location to firebase>

    // Geofire.initialize('sheltersNotAvailable');
    Geofire.initialize('sheltersAvailable');
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

// <update table shelter user : input field 'newShelters == waiting'
    shelterRequestRef = FirebaseDatabase.instance
        .reference()
        .child('shelters/${currentFirebaseUser.uid}/newShelters');
    shelterRequestRef.set('waiting');
    shelterRequestRef.onValue.listen((event) {});
//<end>
  }

//<go offline and remove data from datasbe>
  void goOffline() {
    Geofire.removeLocation(currentFirebaseUser.uid);
    shelterRequestRef.onDisconnect();
    shelterRequestRef.remove();
    shelterRequestRef = null;
  }

//<automatic update of location to firebase database>
  void getUpdate() {
    homeTabPositionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      //<update current position>
      currentPosition = position;

      if (isAvailable) {
        Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
            currentPosition.longitude);
      }
      //<update location on firebase Databse>
      LatLng pos = LatLng(position.latitude, position.longitude);
      CameraPosition cp = new CameraPosition(target: pos, zoom: 12);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    });
  }
}
