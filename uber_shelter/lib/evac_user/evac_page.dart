import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:capstone_project/dataprovider/appdata.dart';
import 'package:capstone_project/models/nearbyShelter.dart';
import 'package:capstone_project/screens/destinationpage.dart';
import 'package:capstone_project/services/firehelpers.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/helpermethods.dart';
import 'package:capstone_project/widgets/bradDivider.dart';
import 'package:capstone_project/widgets/drawer_list.dart';
import 'package:capstone_project/widgets/drawer_nav.dart';
import 'package:capstone_project/widgets/preogressDialog.dart';
import 'package:capstone_project/widgets/wildraisedbutton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class EvacUser extends StatefulWidget {
  @override
  _EvacUserState createState() => _EvacUserState();
}

class _EvacUserState extends State<EvacUser> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  double searchContainerHeight = 330;
  double findContainerHeight = 0;
  double requestingSheetHeight = 0;
  double mapBottomPadding = 0;

  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylinrCoordinates = [];
  Set<Polyline> _polylines = {};
  // ignore: non_constant_identifier_names
  Set<Marker> _Markers = {};
  // ignore: non_constant_identifier_names
  Set<Circle> _Circles = {};
  GoogleMapController mapController;
  var geolocator = Geolocator();
  Position currentPosition;

  DatabaseReference shelterRef;

  bool nearbySheltersKeysLoad = false;

  void setupPositionLocator() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String address =
        await HelperMethods.findCordinateAddress(position, context);
    print(address);

    startGeofireListener();
  }

  void showDetailSheet() async {
    getDirection();
    setState(() {
      searchContainerHeight = 0;
      findContainerHeight = 300;
    });
  }

  void showRequestSheet() {
    setState(() {
      findContainerHeight = 300;
      requestingSheetHeight = 210;
    });
    createShelterRequest();
  }

  @override
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: DrawerList(),
      body: (googlePlexOne != null)
          ? Stack(children: <Widget>[
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.43,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      myLocationEnabled: true,
                      initialCameraPosition: googlePlexOne,
                      polylines: _polylines,
                      markers: _Markers,
                      circles: _Circles,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        mapController = controller;

                        setState(() {
                          mapBottomPadding = 300;
                        });
                        setupPositionLocator();
                      },
                    ),
                  ),
                ],
              ),
              //circle navigation button
              Positioned(
                top: 40,
                left: 20,
                child: GestureDetector(
                    onTap: () {
                      _scaffoldkey.currentState.openDrawer();
                    },
                    child: NavigationDrawer()),
              ),
              //Search Panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 150),
                  curve: Curves.easeIn,
                  child: Container(
                    height: searchContainerHeight,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              spreadRadius: 0.8,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18),
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
                            style: TextStyle(
                                fontSize: 20.0, fontFamily: 'Brand-Bold'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //search box
                          GestureDetector(
                            onTap: () async {
                              var response = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DestinationPage()));
                              if (response == 'getDirection') {
                                showDetailSheet();
                              }
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
                          // Row(
                          //   children: <Widget>[
                          //     Icon(
                          //       OMIcons.home,
                          //       color: Colors.blueGrey,
                          //     ),
                          //     SizedBox(
                          //       width: 12,
                          //     ),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: <Widget>[
                          //         Text(
                          //             // (Provider.of<AppData>(context).pickupAddress != null)
                          //             //   ? Provider.of<AppData>(context).pickupAddress.placeName
                          //             //   :
                          //             'Add Current Location'),
                          //         SizedBox(height: 3),
                          //         Text(
                          //           'Your residential address',
                          //           style: TextStyle(
                          //               fontSize: 11, color: Colors.grey),
                          //         )
                          //       ],
                          //     )
                          //   ],
                          // ),
                          SizedBox(height: 10),
                          BrandDivider(),
                          SizedBox(height: 16),
                          // Row(
                          //   children: <Widget>[
                          //     Icon(
                          //       OMIcons.work,
                          //       color: Colors.blueGrey,
                          //     ),
                          //     SizedBox(
                          //       width: 12,
                          //     ),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: <Widget>[
                          //         Text('Add Work'),
                          //         SizedBox(height: 3),
                          //         Text(
                          //           'Your office address',
                          //           style: TextStyle(
                          //               fontSize: 11, color: Colors.grey),
                          //         )
                          //       ],
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //Ride Details
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  child: Container(
                    height: findContainerHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: <Widget>[
                          //information view
                          Container(
                            width: double.infinity,
                            color: Colors.blue[50],
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/icon_logo.png',
                                    height: 43.0,
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'current location...',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          (Provider.of<AppData>(context)
                                                      .pickupAddress !=
                                                  null)
                                              ? Provider.of<AppData>(context)
                                                  .pickupAddress
                                                  .placeName
                                              : 'current location',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Brand-Regular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Expanded(child: Container()),
                                  // Container(
                                  //   alignment: Alignment.centerRight,
                                  //   child: Text(
                                  //     'Php 300',
                                  //     style: TextStyle(
                                  //         fontSize: 18,
                                  //         fontFamily: 'Brand-Bold'),
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          //cash button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.money),
                                Text('Cash')
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // find available openhouse button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: WildRaisedButton(
                              title: 'FIND SHELTER',
                              color: Colors.blue[400],
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Brand-Bold',
                                fontSize: 17,
                                letterSpacing: 2,
                              ),
                              onPressed: () {
                                showRequestSheet();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //loading waiting for open house shelter
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 800),
                  curve: Curves.easeIn,
                  child: Container(
                    height: requestingSheetHeight,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7))
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 5),
                          SizedBox(
                              width: double.infinity,
                              child: TextLiquidFill(
                                text: 'Requesting a shelter...',
                                waveColor: Colors.black,
                                boxBackgroundColor: Colors.white,
                                textStyle: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                boxHeight: 40.0,
                              )),
                          SizedBox(height: 30),
                          GestureDetector(
                            onDoubleTap: () {
                              cancelrequest();
                              resetApp();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.grey[400],
                                  )),
                              child: Icon(
                                Icons.close,
                                size: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            child: Text('double tap to cancel request'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ])
          : ProgressDialog(),
    );
  }

  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    var thisDetails =
        await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog());
    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylinrCoordinates.clear();
    if (result.isNotEmpty) {
      //loop through all PointLatLng point and concvert them
      //to a list of Latlng, required by the Polynine

      result.forEach((PointLatLng points) {
        polylinrCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('poliid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylinrCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      _polylines.add(polyline);
    });

    LatLngBounds bounds;
    if (pickLatLng.latitude > destinationLatLng.latitude &&
        pickLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
      );
    } else if (pickLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
        northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: 'Destination'),
    );

    setState(() {
      _Markers.add(pickupMarker);
      _Markers.add(destinationMarker);
    });
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: Colors.green,
    );
    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Colors.purple,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: Colors.purple,
    );
    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });
  }

//<view all active shelter on map>
  void startGeofireListener() {
//start viewing all nearby shelter into map with the existing range of 20 kilometers
//view all data from firebasedatabse table 'sheltersAvailable
    Geofire.initialize('sheltersAvailable');
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 20)
        .listen((map) {
      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyShelter nearbyShelter = NearbyShelter();
            nearbyShelter.key = map['key'];
            nearbyShelter.latitude = map['latitude'];
            nearbyShelter.longitude = map['longitude'];
            FireHelper.nearbyShelterList.add(nearbyShelter);

            if (nearbySheltersKeysLoad) {
              updateShleteronMap();
            }
            break;

          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
            updateShleteronMap();
            break;

          case Geofire.onKeyMoved:
            // Update your key's location
            NearbyShelter nearbyShelter = NearbyShelter();
            nearbyShelter.key = map['key'];
            nearbyShelter.latitude = map['latitude'];
            nearbyShelter.longitude = map['longitude'];
            FireHelper.updateNearbyLocation(nearbyShelter);
            updateShleteronMap();

            break;

          case Geofire.onGeoQueryReady:
            nearbySheltersKeysLoad = true;
            updateShleteronMap();
            break;
        }
      }
    });
    // setState(() {});
  }

//<this method will view list of active shelter>
//<this is for shelter also>
  void updateShleteronMap() {
    setState(() {
      _Markers.clear();
    });
    Set<Marker> tempMarkers = Set<Marker>();
    for (NearbyShelter shelter in FireHelper.nearbyShelterList) {
      LatLng shelterPosition = LatLng(shelter.latitude, shelter.longitude);

      Marker thisMarker = Marker(
        markerId: MarkerId('shelter${shelter.key}'),
        position: shelterPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        rotation: HelperMethods.generateRandomNumber(360),
      );
      tempMarkers.add(thisMarker);
    }

    setState(() {
      _Markers = tempMarkers;
    });
  }

//void createEvacueerequest
  void createShelterRequest() {
    //rideRef
    shelterRef =
        FirebaseDatabase.instance.reference().child('shelterRequest').push();

    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;
    Map pickupMap = {
      'latitude': pickup.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };

    Map destinationMap = {
      'latitude': destination.latitude.toString(),
      'longitude': destination.longitude.toString(),
      // 'latitude': pickup.latitude.toString(),
      // 'longitude': pickup.longitude.toString(),
    };

    Map rideMap = {
      'created_at': DateTime.now().toString(),
      //ridername
      'e_username': currentUserInfo.fullName,
      'e_phone': currentUserInfo.phone,
      'e_email': currentUserInfo.email,
      'e_address': currentUserInfo.address,
      'e_gender': currentUserInfo.gender,
      'e_birthday': currentUserInfo.birthday,
      'e_occupation': currentUserInfo.occupation,
      'emergency_name': currentUserInfo.emergencyName,
      //evacuee current address
      'pickup_address': pickup.placeName,
      'destination_address': destination.placeName,
      'location': pickupMap,
      'destination': destinationMap,
      //payment type
      'id_type': 'student',
      //drivers_id
      'shelter_id': 'waiting',
      'status': 'waiting',
    };
    shelterRef.set(rideMap);
  }

//cancel request
  void cancelrequest() {
    shelterRef.remove();
  }

  resetApp() {
    setState(() {
      polylinrCoordinates.clear();
      _polylines.clear();
      _Markers.clear();
      _Circles.clear();
      findContainerHeight = 0;
      requestingSheetHeight = 0;
      searchContainerHeight = 300;
    });
  }
}
