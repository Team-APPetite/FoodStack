import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/services/firestoreCarts.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/numbers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final firestoreService = FirestoreCarts();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<DocumentSnapshot>> pastOrdersList;

  int _joinDuration = 20;
  int _itemCount = 0;
  int _uniqueItemCount = 0;
  var _cartItems = [];

  String _cartId;
  String _restaurantId;
  String _userId;
  double _deliveryFee;
  double _subtotal = 0;

  String get cartId => _cartId;
  int get joinDuration => _joinDuration;

  int get itemCount => _itemCount;

  String get restaurantId => _restaurantId;

  List get cartItems => _cartItems;

  double get deliveryFee => _deliveryFee;

  set joinDuration(int duration) {
    _joinDuration = duration;
    notifyListeners();
  }

  set deliveryFee(double fee) {
    _deliveryFee = fee;
  }

  set restaurantId(String id) {
    _restaurantId = id;
  }

  addToCart(CartItem cartItem) {
    CartItem exists = _cartItems.firstWhere(
        (item) => item.foodId == cartItem.foodId,
        orElse: () => null);

    if (exists == null) {
      _cartItems.add(1);
      _cartItems[_uniqueItemCount] = cartItem;
      _cartItems[_uniqueItemCount].quantity = 1;
      _uniqueItemCount++;
      _itemCount++;
    } else {
      int updateIndex = _cartItems.indexOf(exists);
      _cartItems[updateIndex].quantity++;
      _itemCount++;
    }

    notifyListeners();
  }

  removeFromCart(String foodId) {
    _cartItems.removeWhere((item) => item.foodId == foodId);
    _uniqueItemCount--;
    _itemCount--;
    notifyListeners();
  }

  confirmCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var uuid = Uuid();
    _cartId = uuid.v1();
    prefs.setString('cartId', _cartId);

    _userId = _auth.currentUser.uid;

    List<dynamic> cartItemsList = [];

    _cartItems.forEach((item) => cartItemsList.add(item.toMap()));
    var cart = Cart(_cartId, _userId, _restaurantId, _subtotal, cartItemsList);
    firestoreService.setCart(cart);
  }

  getCart(String cartId) async {
    Cart cart = await firestoreService.getCart(cartId);
    _cartId = cart.cartId;
    _userId = cart.userId;
    _restaurantId = cart.restaurantId;
    _subtotal = cart.subtotal;
    _cartItems = [];
    cart.cartItems.forEach((item) => _cartItems.add(CartItem.fromJson(item)));
  }

  deleteCart(String cartId) {
    firestoreService.deleteCart(cartId);
  }

  clearCart() {
    _itemCount = 0;
    _uniqueItemCount = 0;
    _cartItems = [];
  }

  int getItemQuantityOf(String foodId) {
    CartItem exists = _cartItems.firstWhere((item) => item.foodId == foodId,
        orElse: () => null);

    if (exists == null) {
      return 0;
    } else {
      int updateIndex = _cartItems.indexOf(exists);
      return _cartItems[updateIndex].quantity;
    }
  }

  updateItemQuantityOf(String foodId, int quantity) {
    CartItem exists = _cartItems.firstWhere((item) => item.foodId == foodId,
        orElse: () => null);

    if (exists != null) {
      int updateIndex = _cartItems.indexOf(exists);

      if (quantity == 0) {
        removeFromCart(foodId);
      } else {
        _itemCount = _itemCount - _cartItems[updateIndex].quantity + quantity;
        _cartItems[updateIndex].quantity = quantity;
      }
    }
    notifyListeners();
  }

  getPastOrder(String restaurantId) async {
    Cart cart = await firestoreService.getPastOrder(restaurantId);
    _cartId = cart.cartId;
    _restaurantId = cart.restaurantId;
    _userId = cart.userId;
  }

  Stream<List<DocumentSnapshot>> getPastOrdersList(String uid) {
    pastOrdersList = firestoreService.getPastOrders(uid);
    return firestoreService.getPastOrders(uid);
  }



  Widget itemQuantityIcon() {
    return Stack(
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          size: 60,
          color: ThemeColors.yellows,
        ),
        Positioned(
            bottom: 14,
            left: (_itemCount < 10) ? 25 : 20,
            child: Text(
              '$_itemCount',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  double getSubtotal() {
    _subtotal = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      _subtotal += (_cartItems[i].price * _cartItems[i].quantity);
    }
    _subtotal = Numbers.roundTo2d(_subtotal);
    return _subtotal;
  }

  String deliveryFeeRange() {
    return '\$${_deliveryFee / 5} - \$$_deliveryFee';
  }

  String totalRange() {
    double subtotal = getSubtotal();
    double min = Numbers.roundTo2d(_deliveryFee / 5 + subtotal);
    double max = Numbers.roundTo2d(_deliveryFee + subtotal);
    return '\$$min - \$$max';
  }

  getRestaurantsfromPastOrders(String uid) {
    Stream<List<DocumentSnapshot<Object>>> pastOrders =
    getPastOrdersList(uid);

    Stream<List<String>> restaurantIds = pastOrders.map((snapshot) => snapshot
        .map((doc) => Cart.fromJson(doc.data()))
        .map((e) => e.restaurantId)
        .toList());
    return restaurantIds;
  }
}
