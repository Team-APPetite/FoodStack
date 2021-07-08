import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/services/geolocatorService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';

Position position = Position(
    longitude: 100.00,
    latitude: 1.00,
    timestamp: DateTime.now(),
    accuracy: 1.00,
    altitude: 0.00,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

CameraPosition cameraPosition = CameraPosition(target: LatLng(50.0, 50.0));

class MockGeolocatorService extends Mock implements GeolocatorService {
  Future<Position> getCurrentLocation() async {
    return position;
  }
}

void main() async {
  GeolocatorService geolocatorService = MockGeolocatorService();
  var userLocator = UserLocator(geolocator: geolocatorService);

  group('Geolocating user', () {
    test('Set current location', () {
      expect(userLocator.currentLocation, position);
    });

    test('Get Lat/Lng of location', () {
      expect(
          LatLng(userLocator.coordinates.latitude,
              userLocator.coordinates.longitude),
          LatLng(position.latitude, position.longitude));
    });

    test('Change location on moving map', () {
      userLocator.onCameraMove(cameraPosition);
      expect(userLocator.coordinates, cameraPosition.target);
    });
  });
}
