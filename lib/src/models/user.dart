import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Users {
  String uid;
  String name;
  String email;
  String address;
  GeoFirePoint coordinates;
  List favourites;
  Object getCoordinates;

  Users(
      {@required this.uid,
      this.name,
      this.email,
      this.address,
      this.coordinates,
      this.favourites,
      this.getCoordinates});

  Map<String, dynamic> toMap() {
    if (coordinates != null) {
      return {
        'uid': uid,
        'name': name,
        'email': email,
        'address': address,
        'coordinates': coordinates.data,
        'favourites': favourites
      };
    } else {
      return {'uid': uid, 'name': name, 'email': email};
    }
  }

  Users.fromFirestore(Map<String, dynamic> firestore)
      : uid = firestore['uid'],
        name = firestore['name'],
        email = firestore['email'],
        address = firestore['address'],
        getCoordinates = firestore['coordinates'],
        favourites = firestore['favourites'];
}
