import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/models/order.dart';

class FirestoreOrders {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  //Add Order
  Future<void> addOrder(Order order) {
    return _db
        .collection('order')
        .doc(order.orderId)
        .set(order.toMap());
  }

  //Delete Order
  Future<void> removeOrder(String orderId) {
    return _db.collection('order').doc(orderId).delete();

  }
}
