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
  static const int NoOfMillisecondsPerSecond = 1000;
  static const int noOfSecondsPerMinute = 60;
  static const int maxCarts = 5;

  final firestoreService = FirestoreOrders();
  FirestoreUsers firestoreUser = FirestoreUsers();

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
  Stream<List<DocumentSnapshot>> nearbyOrdersList;

  // Getters
  String get orderId => _orderId;
  String get restaurantId => _restaurantId;
  String get creatorId => _creatorId;
  String get paymentId => _paymentId;
  String get status => _status;
  String get deliveryAddress => _deliveryAddress;
  DateTime get orderTime => _orderTime != null
      ? DateTime.fromMillisecondsSinceEpoch(
          _orderTime.seconds * NoOfMillisecondsPerSecond)
      : null;
  double get totalPrice => _totalPrice;
  List get cartIds => _cartIds;

  set orderId(String orderId) {
    _orderId = orderId;
    notifyListeners();
  }

  Stream<List<DocumentSnapshot>> getNearbyOrdersList(
          GeoFirePoint center, double radius) {
    nearbyOrdersList = firestoreService.getNearbyOrders(center, radius);
      return firestoreService.getNearbyOrders(center, radius);
  }

  // Functions
  setOrder(Order order, int joinDurationMins) {
    _orderId = uuid.v4();
    _restaurantId = order.restaurantId;
    _creatorId = FirebaseAuth.instance.currentUser.uid;
    _paymentId = null;
    _status = Status.active.toString();
    _deliveryAddress = order.deliveryAddress;
    _coordinates = order.coordinates;
    _totalPrice = order.totalPrice;
    _cartIds = order.cartIds;

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
      cartIds: _cartIds,
    );

    return firestoreService
        .addOrder(newOrder)
        .then((value) => print('Order Saved'))
        .catchError((error) => print(error));

  }

  getOrder(String restaurantId) async {
    Order order = await firestoreService.getNearbyOrder(restaurantId);
      _orderId = order.orderId;
      _restaurantId = order.restaurantId;
      _creatorId = order.creatorId;
      _paymentId = order.paymentId;
      _status = order.status;
      _deliveryAddress = order.deliveryAddress;
      _coordinates = order.coordinates;
      _orderTime = order.orderTime;
      _totalPrice = order.totalPrice;
      _cartIds = order.cartIds;
  }

  removeOrder(String orderId) {
    firestoreService.removeOrder(orderId);
  }

  clearOrder() {
    _orderId = null;
    _restaurantId = null;
    _creatorId = null;
    _paymentId = null;
    _status = null;
    _deliveryAddress = null;
    _coordinates = null;
    _orderTime = null;
    _totalPrice = null;
    _cartIds = null;
  }

  addToCartsList(String cartId, String orderId) {
    int length = _cartIds.length;
    _cartIds.add(1);
    _cartIds[length] = cartId;
    length++;

    if (length >= maxCarts) {
      firestoreService.setStatus(Status.full.toString(), orderId);
    }
    firestoreService.addToCartsList(cartId, orderId);
  }

}
