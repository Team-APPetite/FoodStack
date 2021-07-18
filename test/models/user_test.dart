import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/user.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

Geoflutterfire geo = Geoflutterfire();
GeoFirePoint location = geo.point(latitude: 1.00, longitude: 100.0);

Users mockUser = Users(
    uid: "123",
    name: "John Doe",
    email: "johndoe1995@email.com",
    address: "7th Street",
    coordinates: location,
    favourites: ["1011"]);

var jsonUser = {
  "uid": "123",
  "name": "John Doe",
  "email": "johndoe1995@email.com",
  "address": "7th Street",
  "coordinates": location.data,
  "favourites": ["1011"]
};

void main() async {
  group('User model', () {
    test('From json', () {
      Users user = Users.fromFirestore(jsonUser);
      expect(user.uid, mockUser.uid);
      expect(user.name, mockUser.name);
      expect(user.email, mockUser.email);
      expect(user.address, mockUser.address);
      expect(user.getCoordinates, mockUser.coordinates.data);
      expect(user.favourites, mockUser.favourites);
    });

    test('To map', () {
      expect(mockUser.toMap(), jsonUser);
    });
  });
}
