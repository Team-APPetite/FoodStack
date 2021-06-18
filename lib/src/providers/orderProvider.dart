import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodstack/src/services/firestoreOrders.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/utilities/statusEnums.dart';
import 'package:uuid/uuid.dart';
import 'package:foodstack/src/models/order.dart';

class OrderProvider with ChangeNotifier {
  final firestoreService = FirestoreOrders();
  FirestoreUsers firestoreUser = FirestoreUsers();


   String _orderId;
   String _restaurantId;
   String _creatorId;
   String _paymentId;
   Status _status;
   String _deliveryAddress;
   Timestamp _orderTime;
   double _totalPrice;
   String _cartId;

  var uuid = Uuid();

  // Getters
   String get orderId => _orderId;
   String get restaurantId => _restaurantId;
   String get creatorId => _creatorId;
   String get paymentId => _paymentId;
   Status get status => _status;
   String get deliveryAddress => _deliveryAddress;
   Timestamp get orderTime => _orderTime;
   double get totalPrice => _totalPrice;
   String get cartId => _cartId;




  // Functions
  addOrder(Order order) {
    if (order.orderId != null) {
      _orderId = order.orderId;
    } else {
      _orderId = uuid.v1();
    }

    _restaurantId = order.restaurantId;
    _creatorId = FirebaseAuth.instance.currentUser.uid;
    _paymentId = null;
    _status = Status.active;
    _deliveryAddress = order.deliveryAddress;
    _orderTime = order.orderTime;
    _totalPrice = order.totalPrice;
    _cartId = order.cartId;

    var newOrder = Order(
        orderId: _orderId,
        restaurantId: _restaurantId,
        creatorId: _creatorId,
        paymentId: _paymentId,
        status: _status,
        deliveryAddress: _deliveryAddress,
        orderTime: _orderTime,
        totalPrice: _totalPrice,
        cartId: _cartId);

    firestoreService.addOrder(newOrder);
  }

  removeRestaurant(String orderId) {
    firestoreService.removeOrder(restaurantId);
  }
}