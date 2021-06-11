import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/user.dart';

class FirestoreUsers {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Set User
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



}