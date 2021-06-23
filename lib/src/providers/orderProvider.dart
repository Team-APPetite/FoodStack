import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/services/firestoreOrders.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/utilities/statusEnums.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:uuid/uuid.dart';
import 'package:foodstack/src/models/order.dart';

class OrderProvider with ChangeNotifier {
  final firestoreService = FirestoreOrders();
  FirestoreUsers firestoreUser = FirestoreUsers();

  int NoOfMillisecondsinSecond = 1000;

  String _orderId;
  String _restaurantId;
  String _creatorId;
  String _paymentId;
  String _status;
  String _deliveryAddress;
  Object _coordinates;
  Timestamp _orderTime;
  double _totalPrice;
  List _cartIds;

  var uuid = Uuid();

  // Getters
  String get orderId => _orderId;
  String get restaurantId => _restaurantId;
  String get creatorId => _creatorId;
  String get paymentId => _paymentId;
  String get status => _status;
  String get deliveryAddress => _deliveryAddress;
  DateTime get orderTime => DateTime.fromMillisecondsSinceEpoch(_orderTime.seconds * NoOfMillisecondsinSecond);
  double get totalPrice => _totalPrice;
  List get cartIds => _cartIds;

  Stream<List<DocumentSnapshot>> getNearbyOrdersList(
          GeoFirePoint center, double radius) =>
      firestoreService.getNearbyOrders(center, radius).take(10);

  // Functions
  setOrder(Order order, int joinDurationMins, String newCartId) {
    int noOfSecondsPerMinute = 60;
    _orderId = uuid.v4();
    _restaurantId = order.restaurantId;
    _creatorId = FirebaseAuth.instance.currentUser.uid;
    _paymentId = null;
    _status = Status.active.toString();
    _deliveryAddress = order.deliveryAddress;
    _coordinates = order.coordinates;
    _totalPrice = order.totalPrice;

    Timestamp currentTime = Timestamp.now();
    int seconds =
        currentTime.seconds + (joinDurationMins * noOfSecondsPerMinute);
    int nanoseconds = currentTime.nanoseconds;
    Timestamp orderCompletionTime = Timestamp(seconds, nanoseconds);
    _orderTime = orderCompletionTime;
    print(_orderTime);

    var newOrder = Order(
      orderId: _orderId,
      restaurantId: _restaurantId,
      creatorId: _creatorId,
      paymentId: _paymentId,
      status: _status,
      deliveryAddress: _deliveryAddress,
      coordinates: _coordinates,
      orderTime: _orderTime,
      totalPrice: _totalPrice,
    );

    firestoreService
        .addOrder(newOrder)
        .then((value) => print('Order Saved'))
        .catchError((error) => print(error));
    return firestoreService.addToCartsList(newCartId, _orderId);
  }

  getOrder(String orderId) {
    firestoreService.getOrder(orderId).then((order) {
      _orderId = order.orderId;
      _restaurantId = order.restaurantId;
      _creatorId = order.creatorId;
      _paymentId = order.paymentId;
      _status = order.status;
      _deliveryAddress = order.deliveryAddress;
      _coordinates = order.coordinates;
      _orderTime = order.orderTime;
      _totalPrice = order.totalPrice;
    }).catchError((error) => print(error));
  }

  removeOrder(String orderId) {
    firestoreService.removeOrder(orderId);
  }
}
