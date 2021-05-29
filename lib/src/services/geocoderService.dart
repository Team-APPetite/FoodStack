import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocoderService {
  var deliveryAddress;

  Future<void> getCameraLocation(LatLng latLng) async {
    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.deliveryAddress = addresses.first;
    print("${deliveryAddress.featureName} : ${deliveryAddress.addressLine}");
  }
}
