import 'package:flutter/material.dart';
import 'package:foodstack/src/services/geolocatorService.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart' hide Coordinates;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocator with ChangeNotifier {
  var geolocatorService = GeolocatorService();

  Position currentLocation;
  LatLng coordinates;
  Address deliveryAddress;
  bool isOnline = true;

  UserLocator({GeolocatorService geolocator}) {
    geolocatorService = geolocator != null ? geolocator : geolocatorService;
    setCurrentLocation();
  }

  setCurrentLocation() async {
    isOnline = true;
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
    isOnline = true;
    try {
      final addresses = await Geocoder.local.findAddressesFromCoordinates(
          new Coordinates(coordinates.latitude, coordinates.longitude));
      this.deliveryAddress = addresses.first;
      print("${deliveryAddress.featureName} : ${deliveryAddress.addressLine}");
      notifyListeners();
    } catch (error) {
      if (error.toString() ==
          "PlatformException(Error 2, kCLErrorDomain, The operation couldn’t be completed. (kCLErrorDomain error 2.), null)") {
        isOnline = false;
      }
    }
  }

  GeoFirePoint getUserLocation() {
    final geo = Geoflutterfire();
    GeoFirePoint userLocation;

    if (coordinates != null) {
      userLocation = geo.point(
          latitude: coordinates.latitude, longitude: coordinates.longitude);
    }

    return userLocation;
  }
}
