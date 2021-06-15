import 'package:flutter/cupertino.dart';

class Users {
  String uid;
  String name;
  String email;
  String address;
  List favourites;

  Users(
      {@required this.uid,
      this.name,
      this.email,
      this.address,
      this.favourites});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'favourites': favourites
    };
  }

  Users.fromFirestore(Map<String, dynamic> firestore)
      : uid = firestore['uid'],
        name = firestore['name'],
        email = firestore['email'],
        address = firestore['address'],
        favourites = firestore['favourites'];
}
