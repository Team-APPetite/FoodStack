import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/utilities/statusEnums.dart';

class Order {
  final String orderId;
  final String restaurantId;
  final String creatorId;
  final String paymentId;
  final Status status;
  final String deliveryAddress;
  final Timestamp orderTime;
  final double totalPrice;
  final String cartId;


  Order({@required this.orderId,
    this.restaurantId,
    this.creatorId,
    this.paymentId,
    this.status,
    this.deliveryAddress,
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
      'orderTime': orderTime,
      'totalPrice': totalPrice,
      'cartId': cartId,
    };
  }
}