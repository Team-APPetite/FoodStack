import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Order {
  final String orderId;
  final String restaurantId;
  final String restaurantName;
  final String creatorId;
  final String paymentId;
  final String status;
  final String deliveryAddress;
  final GeoFirePoint coordinates;
  final Timestamp orderTime;
  final double totalPrice;
  final List cartIds;
  final Object getCoordinates;

  Order(
      {this.orderId,
      this.restaurantId,
      this.restaurantName,
      this.creatorId,
      this.paymentId,
      this.status,
      this.deliveryAddress,
      this.coordinates,
      this.orderTime,
      this.totalPrice,
      this.cartIds,
      this.getCoordinates});

  factory Order.fromFirestore(Map<String, dynamic> firestore) {
    return Order(
        orderId: firestore['orderId'],
        restaurantId: firestore['restaurantId'],
        restaurantName: firestore['restaurantName'],
        creatorId: firestore['creatorId'],
        paymentId: firestore['paymentId'],
        status: firestore['status'],
        deliveryAddress: firestore['deliveryAddress'],
        getCoordinates: firestore['coordinates'],
        orderTime: firestore['orderTime'],
        totalPrice: firestore['totalPrice'],
        cartIds: firestore['cartIds'],
        coordinates: null);
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'creatorId': creatorId,
      'paymentId': paymentId,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'coordinates': coordinates.data,
      'orderTime': orderTime,
      'totalPrice': totalPrice,
      'cartIds': cartIds,
    };
  }
}
