import 'package:flutter/material.dart';
import 'package:foodstack/src/services/geolocatorService.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocator with ChangeNotifier {
  var geolocatorService = GeolocatorService();

  Position currentLocation;
  LatLng coordinates;
  Address deliveryAddress;

  UserLocator({GeolocatorService geolocator}) {
    geolocatorService = geolocator;
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geolocatorService.getCurrentLocation();
    coordinates = LatLng(currentLocation.latitude, currentLocation.longitude);
    getCameraLocation();
    notifyListeners();
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    coordinates =
        LatLng(cameraPosition.target.latitude, cameraPosition.target.longitude);
    notifyListeners();
  }

  Future<void> getCameraLocation() async {
    final addresses = await Geocoder.local.findAddressesFromCoordinates(
        new Coordinates(coordinates.latitude, coordinates.longitude));
    this.deliveryAddress = addresses.first;
    print("${deliveryAddress.featureName} : ${deliveryAddress.addressLine}");
    notifyListeners();
  }
}
