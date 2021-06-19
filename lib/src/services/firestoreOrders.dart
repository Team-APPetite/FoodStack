import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/order.dart';

class FirestoreOrders {
  FirebaseFirestore _db = FirebaseFirestore.instance;


  //Add Order
  Future<void> addOrder(Order order) {
    var options = SetOptions(merge: true);
    return _db
        .collection('order')
        .doc(order.orderId)
        .set(order.toMap(), options);
  }

  //Delete Order
  Future<void> removeOrder(String orderId) {
    return _db.collection('order').doc(orderId).delete();

  }
}
