import 'package:nearest_evacuation/services/geolocator_service.dart';
import 'package:nearest_evacuation/services/globalvariable.dart';
import 'package:nearest_evacuation/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dataprovider/appdata.dart';
import 'models/place.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          title: 'Nearest Evacuation',
          theme: ThemeData(
            fontFamily: 'Brand-Regular',
            primarySwatch: Colors.blue,
          ),
          home: Search(),
        ),
      ),
    );
  }
}
