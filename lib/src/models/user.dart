import 'package:flutter/cupertino.dart';

class Users {
  String uid;
  String name;
  String email;
  String address;

  Users({
    @required this.uid,
    this.name,
    this.email,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
    };
  }

  Users.fromFirestore(Map<String, dynamic> firestore)
    :uid = firestore['uid'],
     name = firestore['name'],
     email = firestore ['email'],
     address = firestore['address'];
}
