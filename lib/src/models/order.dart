import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Order {
  final String orderId;
  final String restaurantId;
  final String creatorId;
  final String paymentId;
  final String status;
  final String deliveryAddress;
  final GeoFirePoint coordinates;
  final Timestamp orderTime;
  final double totalPrice;
  final List cartId;
  final Object getCoordinates;

  Order(
      {this.orderId,
      this.restaurantId,
      this.creatorId,
      this.paymentId,
      this.status,
      this.deliveryAddress,
      this.coordinates,
      this.orderTime,
      this.totalPrice,
      this.cartId,
      this.getCoordinates});

  Order.fromFirestore(Map<String, dynamic> firestore)
      : orderId = firestore['orderId'],
        restaurantId = firestore['restaurantId'],
        creatorId = firestore['creatorId'],
        paymentId = firestore['paymentId'],
        status = firestore['status'],
        deliveryAddress = firestore['deliveryAddress'],
        getCoordinates = firestore['coordinates'],
        orderTime = firestore['orderTime'],
        totalPrice = firestore['totalPrice'],
        cartId = firestore['cartId'],
        coordinates = null;

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'restaurantId': restaurantId,
      'creatorId': creatorId,
      'paymentId': paymentId,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'coordinates': coordinates.data,
      'orderTime': orderTime,
      'totalPrice': totalPrice,
      'cartId': cartId,
    };
  }
}
