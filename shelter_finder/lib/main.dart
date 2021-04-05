// import 'package:capstone_project/pages/fisrt_screen.dart';
import 'dart:io';
import 'package:capstone_project/screens/homescreen.dart';
import 'package:capstone_project/screens/login_page.dart';
import 'package:capstone_project/services/geolocator_service.dart';
import 'package:capstone_project/services/globalvariable.dart';
import 'package:capstone_project/services/places_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dataprovider/appdata.dart';
import 'models/place.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:297855924061:ios:c6de2b69b03a5be8',
            apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
            projectId: 'flutter-firebase-plugins',
            messagingSenderId: '297855924061',
            databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
          )
        : FirebaseOptions(
            appId: '1:338558586419:android:ad3ec5b7a6c3d859aa1d46',
            apiKey: 'AIzaSyBFsUqH4TWWuSfQ-XVHP1GZUDUfg5ORF6g',
            messagingSenderId: '297855924061',
            projectId: 'capstoneproject-8037d',
            databaseURL: 'https://capstoneproject-8037d.firebaseio.com',
          ),
  );

  currentFirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MultiProvider(
        providers: [
          FutureProvider(create: (context) => locatorService.getLocation()),
          FutureProvider(create: (context) {
            ImageConfiguration configuration =
                createLocalImageConfiguration(context);
            return BitmapDescriptor.fromAssetImage(
                configuration, 'assets/images/icon_logo.png');
          }),
          ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
            update: (context, position, icon, places) {
              return (position != null)
                  ? placesService.getPlaces(
                      position.latitude, position.longitude, icon)
                  : null;
            },
          )
        ],
        child: MaterialApp(
          // darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Login',
          theme: ThemeData(
            fontFamily: 'Brand-Regular',
            primarySwatch: Colors.blue,
          ),
          // home: LoginPage(),
          initialRoute:
              (currentFirebaseUser == null) ? LoginPage.id : HomeScreen.id,
          routes: {
            HomeScreen.id: (context) => HomeScreen(),
            LoginPage.id: (context) => LoginPage(),
          },
        ),
      ),
    );
  }
}
