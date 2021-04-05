import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestShelter {
  String destinationAddress;
  String pickupAddress;
  LatLng pickup;
  LatLng destination;
  String requestID;
  String evacUsername;
  String evacPhone;
  String evacEmail;
  String evacAddress;
  String evacOccupation;

  RequestShelter({
    this.destinationAddress,
    this.pickupAddress,
    this.destination,
    this.pickup,
    this.evacUsername,
    this.evacPhone,
    this.evacEmail,
    this.requestID,
    this.evacAddress,
    this.evacOccupation,
  });
}
