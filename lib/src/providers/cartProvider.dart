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

  int _joinDuration = 20;
  int _itemCount = 0;
  int _uniqueItemCount = 0;
  var _cartItems = [];

  String _cartId;
  String _restaurantId;
  String _restaurantName;
  String _userId;
  double _deliveryFee;
  double _subtotal = 0;
  Timestamp _orderTime = Timestamp(0, 0);

  String get cartId => _cartId;
  int get joinDuration => _joinDuration;

  int get itemCount => _itemCount;

  String get restaurantId => _restaurantId;

  String get restaurantName => _restaurantName;

  List get cartItems => _cartItems;

  double get deliveryFee => _deliveryFee;

  double get subtotal => _subtotal;

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

  set restaurantName(String name) {
    _restaurantName = name;
  }

  addToCart(CartItem cartItem) {
    CartItem exists = _cartItems.firstWhere(
        (item) => item.foodId == cartItem.foodId,
        orElse: () => null);

    if (exists == null) {
      _cartItems.add(1);
      _cartItems[_uniqueItemCount] = cartItem;
      _cartItems[_uniqueItemCount].quantity = cartItem.quantity;
      _itemCount = _itemCount + _cartItems[_uniqueItemCount].quantity;
      _uniqueItemCount++;
    } else {
      int updateIndex = _cartItems.indexOf(exists);
      if (cartItem.notes != _cartItems[updateIndex].notes) {
        for (int i = 0; i < cartItem.quantity; i++) {
          _cartItems[updateIndex].notes += '; \n${cartItem.notes}';
        }
      }
      _cartItems[updateIndex].quantity += cartItem.quantity;
      _itemCount += cartItem.quantity;
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
    if (_auth.currentUser != null) {
      _userId = _auth.currentUser.uid;

      List<dynamic> cartItemsList = [];

      _cartItems.forEach((item) => cartItemsList.add(item.toMap()));
      var cart = Cart(_cartId, _userId, _restaurantId, _restaurantName,
          _subtotal, _deliveryFee, cartItemsList, Timestamp.now());
      firestoreService.setCart(cart);
    }
  }

  getCart(String cartId) async {
    Cart cart = await firestoreService.getCart(cartId);
    _cartId = cart.cartId;
    _userId = cart.userId;
    _restaurantId = cart.restaurantId;
    _restaurantName = cart.restaurantName;
    _subtotal = cart.subtotal;
    _deliveryFee = cart.deliveryFee;
    _cartItems = [];
    _orderTime = cart.orderTime;
    cart.cartItems.forEach((item) => _cartItems.add(CartItem.fromJson(item)));
  }

  deleteCart(String cartId) {
    clearCart();
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

  Stream<List<Cart>> getRecentCartsList(String uid) {
    return firestoreService.getRecentCarts(uid);
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
}
