import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String foodId;
  String foodName;
  String image;
  double price;
  int quantity;
  String notes;

  CartItem(
      {this.foodId,
      this.foodName,
      this.image,
      this.price,
      this.quantity,
      this.notes,});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        foodId: json['foodId'],
        foodName: json['foodName'],
        image: json['image'],
        price: json['price'],
        quantity: json['quantity'],
        notes: json['notes'],);
  }

  Map<String, dynamic> toMap() => {
        "foodId": this.foodId,
        "foodName": foodName,
        "image": image,
        "price": price,
        "quantity": this.quantity,
        "notes": this.notes,
      };
}

class Cart {
  String cartId;
  String userId;
  String restaurantId;
  String restaurantName;
  double subtotal;
  double deliveryFee;
  List<dynamic> cartItems = [];
  Timestamp orderTime;

  Cart(this.cartId, this.userId, this.restaurantId, this.restaurantName,
      this.subtotal, this.deliveryFee, this.cartItems,
      this.orderTime);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        json['cartId'],
        json['userId'],
        json['restaurantId'],
        json['restaurantName'],
        json['subtotal'],
        json['deliveryFee'],
        json['cartItems'],
        json['orderTime']);
  }

  Map<String, dynamic> toMap() => {
        "cartId": this.cartId,
        "userId": this.userId,
        "restaurantId": this.restaurantId,
        "restaurantName": this.restaurantName,
        "subtotal": this.subtotal,
        "deliveryFee": this.deliveryFee,
        "cartItems": this.cartItems,
        "orderTime": this.orderTime,
      };
}
