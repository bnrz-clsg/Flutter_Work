import 'package:geolocator/geolocator.dart';

// class GeoLocatorService {
//   Future<Position> getLocation() async {
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//## this is the old shit.
class GeoLocatorService {
  final geolocator = Geolocator();
  Future<Position> getLocation() async {
    return await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        locationPermissionLevel: GeolocationPermission.location);
  }

  Future<double> getDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    return await geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}
