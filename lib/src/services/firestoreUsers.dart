import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/models/user.dart';

class FirestoreUsers {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  //Set User uid, name and email
  Future<void> addUser(Users user) {
    return _db.collection('users').doc(user.uid).set(user.toMap());
  }

  //Fetch User
  Future<Users> fetchUser(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) => Users.fromFirestore(snapshot.data()));
  }

  //Update user address
  Future<void> updateUser(String address) {
    CollectionReference users = _db.collection('users');
    var currUid = _auth.currentUser.uid;
    return users
        .doc(currUid)
        .update({'address': address})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }



}