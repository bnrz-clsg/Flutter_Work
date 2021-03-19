import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:capstone_project/models/shelters.dart';
import 'package:capstone_project/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = '<YOUR MAP KEY HERE>';

final CameraPosition googlePlexOne = CameraPosition(
  target: LatLng(14.5953, 120.9880),
  zoom: 14.4746,
);

User currentFirebaseUser;
MeUser currentUserInfo;
Shelters currentSheltersInfo;

DatabaseReference shelterRequestRef;
DatabaseReference requestRef;

Position currentPosition;

StreamSubscription<Position> homeTabPositionStream;

final assetsAudioPlayer = AssetsAudioPlayer();






