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
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TesterClass extends StatefulWidget {
  @override
  _TesterClassState createState() => _TesterClassState();
}

class _TesterClassState extends State<TesterClass> {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  double searchContainerHeight = 0; //not needed
  double findContainerHeight = 250;
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

// online shelter ICon
  BitmapDescriptor nearbyIcon;

  DatabaseReference shelterRef;

  bool nearbySheltersKeysLoad = false;

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

    startGeofireListener();
  }

  void showDetailSheet() async {
    getDirection();
    setState(() {
      searchContainerHeight = 0;
      findContainerHeight = 250;
    });
  }

  void showRequestSheet() {
    setState(() {
      findContainerHeight = 250;
      requestingSheetHeight = 205;
    });
    createShelterRequest();
  }

// nearbysheltyer Icon
  void createMarker() {
    if (nearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/nearbyIcon.png')
          .then((icon) {
        nearbyIcon = icon;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      key: _scaffoldkey,
      drawer: DrawerList(),
      body: (googlePlexOne != null)
          ? Stack(children: <Widget>[
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.32,
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
              //
              //<Circle Navigation button>
              Positioned(
                  top: 70,
                  left: 30,
                  child: GestureDetector(
                      onTap: () {
                        _scaffoldkey.currentState.openDrawer();
                      },
                      child: NavigationDrawer())),
              //
              //<Search Panel, Search Prediction> not needed to be remove
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
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
                        SizedBox(height: 5.0),
                        Text(
                          'Nice to See you!',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Search for Open-House Shelter?',
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: 'Brand-Bold'),
                        ),
                        SizedBox(height: 20),
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
                        SizedBox(
                          height: 10,
                        ),
                        BrandDivider(),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //<Request for Open-House-Shelter>
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  height: findContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
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
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //information view
                        SizedBox(height: 5.0),
                        Text(
                          'Nice to See you!',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/icon_logo.png',
                              height: 43.0,
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'current location...',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                        letterSpacing: 1.5),
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
                                        fontSize: 16,
                                        fontFamily: 'Brand-Regular',
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        BrandDivider(),

                        SizedBox(height: 25),
                        // find available openhouse button
                        Center(
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
              //<loading waiting for open house shelter>
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
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
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
            ])
          : ProgressDialog(),
    );
  }

//<Get dirention>
  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog());
    Navigator.pop(context);

    // PolylinePoints polylinePoints = PolylinePoints();

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

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );

    setState(() {
      _Markers.add(pickupMarker);
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

//void createEvacueerequest
  void createShelterRequest() {
    //rideRef
    shelterRef =
        FirebaseDatabase.instance.reference().child('shelterRequest').push();

    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    // var destination =
    //     Provider.of<AppData>(context, listen: false).destinationAddress;
    Map pickupMap = {
      'latitude': pickup.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };

    Map rideMap = {
      'created_at': DateTime.now().toString(),
      //ridername
      'evac_name': currentUserInfo.fullName,
      'evac_phone': currentUserInfo.phone,
      'emergency_name': currentUserInfo.emergencyName,
      //evacuee current address
      // 'pickup_address': pickup.placeName,
      'current_location': pickup.placeName,
      'location': pickupMap,
      //payment type
      'id_type': 'student',
      //drivers_id
      'shelter_id': 'waiting',
    };
    shelterRef.set(rideMap);
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
        icon: nearbyIcon,
        rotation: HelperMethods.generateRandomNumber(360),
      );
      tempMarkers.add(thisMarker);
    }

    setState(() {
      _Markers = tempMarkers;
    });
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
      findContainerHeight = 250;
      requestingSheetHeight = 0;
      searchContainerHeight = 0;
    });
  }
}
