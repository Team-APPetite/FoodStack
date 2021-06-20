import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreOrders {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final geo = Geoflutterfire();

  //Add Order
  Future<void> addOrder(Order order) {
    var options = SetOptions(merge: true);
    return _db
        .collection('orders')
        .doc(order.orderId)
        .set(order.toMap(), options);
  }

  //Delete Order
  Future<void> removeOrder(String orderId) {
    return _db.collection('orders').doc(orderId).delete();
  }

  Stream<List<DocumentSnapshot>> getNearbyOrders(GeoFirePoint center, double radius) {
    return geo.collection(collectionRef: _db.collection('orders').where('status', isEqualTo: 'Status.active').limit(10))
        .within(center: center, radius: radius, field: 'coordinates');
  }
}
