import 'package:flutter/material.dart';
import 'package:foodstack/src/services/geolocatorService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocator with ChangeNotifier {
  final geolocatorService = GeolocatorService();

  Position currentLocation;
  LatLng coordinates;

  UserLocator() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geolocatorService.getCurrentLocation();
    coordinates = LatLng(currentLocation.latitude, currentLocation.longitude);
    notifyListeners();
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    coordinates =
        LatLng(cameraPosition.target.latitude, cameraPosition.target.longitude);
    notifyListeners();
  }
}
