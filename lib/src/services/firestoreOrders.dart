import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreOrders {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final geo = Geoflutterfire();
  GeoFirePoint userLocation;
  double ordersRadius;

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

  // Get order
  Future<Order> getOrder(String orderId) {
    print("getOrder");
    return _db
        .collection('orders')
        .doc(orderId)
        .get()
        .then((snapshot) => Order.fromFirestore(snapshot.data()));
  }

  // Get list of orders near to user location
  Stream<List<DocumentSnapshot>> getNearbyOrders(
      GeoFirePoint center, double radius) {
    print("getNearbyOrders");
      userLocation = center;
      ordersRadius = radius;
      return geo
          .collection(
          collectionRef: _db
              .collection('orders')
              .where('status', isEqualTo: 'Status.active')
              .limit(10))
          .within(center: center, radius: radius, field: 'coordinates');

  }

  Future<Order> getNearbyOrder(String restaurantId) {
    print("getNearbyOrder");
    return geo
        .collection(
            collectionRef: _db
                .collection('orders')
                .where('status', isEqualTo: 'Status.active')
                .where('restaurantId', isEqualTo: restaurantId))
        .within(
            center: userLocation, radius: ordersRadius, field: 'coordinates')
        .map((snapshot) =>
            snapshot.map((doc) => Order.fromFirestore(doc.data())).first)
        .first;
  }

  //Add cartId to orders database
  Future<void> addToCartsList(String cartId, String orderId) async {
    CollectionReference orders = _db.collection('orders');
    List addCart = [cartId];
    return orders
        .doc(orderId)
        .update({'cartIds': FieldValue.arrayUnion(addCart)})
        .then((value) => print("Order Updated"))
        .catchError((error) => print("Failed to update order: $error"));
  }

  //Remove cartId from orders database
  Future<void> removeFromCartsList(String cartId, String orderId) async {
    CollectionReference orders = _db.collection('orders');
    List removeCart = [cartId];
    return orders
        .doc(orderId)
        .update({'cartIds': FieldValue.arrayRemove(removeCart)})
        .then((value) => print("Order Updated"))
        .catchError((error) => print("Failed to update order: $error"));
  }

  Future<void> setStatus(String status, String orderId) {
    print("setStatus");
    CollectionReference users = _db.collection('orders');
    return users
        .doc(orderId)
        .update({'status': status})
        .then((value) => print("Status Updated"))
        .catchError((error) => print("Failed to update status: $error"));
  }
}
