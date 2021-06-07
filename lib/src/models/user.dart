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

  Users.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;

    return data;
  }
}
