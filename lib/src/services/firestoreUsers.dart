import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/models/user.dart';
import 'package:foodstack/src/services/analyticsService.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreUsers {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  AnalyticsService _analyticsService = AnalyticsService();

  //Set User uid, name and email
  Future<void> addUser(Users user) {
    return _db
        .collection('users')
        .doc(user.uid)
        .set(user.toMap())
        .catchError((error) => print(error));
  }

  //Fetch User
  Future<Users> fetchUser(String uid) {
    print("fetchUser");
    return _db
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) => Users.fromFirestore(snapshot.data()));
  }

  //Update user address
  Future<void> updateAddress(String uid, String address) {
    CollectionReference users = _db.collection('users');
    return users
        .doc(uid)
        .update({'address': address})
        .then((value) => print("Address Updated"))
        .catchError((error) => print("Failed to update address: $error"));
  }

  Future<void> updateCoordinates(String uid, GeoFirePoint coordinates) {
    CollectionReference users = _db.collection('users');
    return users
        .doc(uid)
        .update({'coordinates': coordinates.data})
        .then((value) => print("Coordinates Updated"))
        .catchError((error) => print("Failed to update Coordinates: $error"));
  }

  //Update user display name
  Future<void> updateName(String name) {
    CollectionReference users = _db.collection('users');
    var currUid = _auth.currentUser.uid;
    return users
        .doc(currUid)
        .update({'name': name})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //Add restaurant to user favourites array
  Future<void> addToFavourites(Restaurant restaurant) async {
    CollectionReference users = _db.collection('users');
    var currUid = _auth.currentUser.uid;
    List addFavourite = [restaurant.staticToMap()];
    return users
        .doc(currUid)
        .update({'favourites': FieldValue.arrayUnion(addFavourite)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //Remove restaurant from user favourites array
  Future<void> removeFromFavourites(Restaurant restaurant) async {
    CollectionReference users = _db.collection('users');
    var currUid = _auth.currentUser.uid;
    List removeFavourite = [restaurant.staticToMap()];
    return users
        .doc(currUid)
        .update({'favourites': FieldValue.arrayRemove(removeFavourite)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    var currUid = _auth.currentUser.uid;

    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .doc(currUid)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
      });
    }
  }

  setUserProperties() async {
    if (_auth.currentUser != null) {
      var currUid = _auth.currentUser.uid;
      await _analyticsService.setUserProperties(currUid);
    }
  }
}
