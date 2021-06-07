import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/models/user.dart';

class FirestoreUsers {

  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create
  Stream<List<Users>> getUser() {
    return _db.collection('user').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());
  }

  // Read and Update
  Future<void> setUser(Users user) {
    var options = SetOptions(merge: true);

    return _db
        .collection('user')
        .doc(user.uid)
        .set(user.toJson(), options);
  }

  // Delete
  Future<void> removeUser(String uid) {
    return _db.collection('user').doc(uid).delete();
  }
}



