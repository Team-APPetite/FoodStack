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
  final String cartId;


  Order({this.orderId,
    this.restaurantId,
    this.creatorId,
    this.paymentId,
    this.status,
    this.deliveryAddress,
    this.coordinates,
    this.orderTime,
    this.totalPrice,
    this.cartId});

  Order.fromFirestore(Map<String, dynamic> firestore)
  :orderId = firestore['orderId'],
   restaurantId = firestore['restaurantId'],
   creatorId = firestore['creatorId'],
   paymentId = firestore['paymentId'],
   status = firestore['status'],
   deliveryAddress = firestore['deliveryAddress'],
   coordinates = firestore['coordinates'],
   orderTime = firestore['orderTime'],
   totalPrice = firestore['totalPrice'],
   cartId = firestore['cartId'];


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