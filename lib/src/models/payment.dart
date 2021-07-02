import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String paymentId;
  final String orderId;
  final String userId;
  final double amountPaid;
  final String paymentMethod;
  final Timestamp paymentTime;

  Payment(
      {this.paymentId,
      this.orderId,
      this.userId,
      this.amountPaid,
      this.paymentMethod,
      this.paymentTime});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        paymentId: json['paymentId'],
        orderId: json['orderId'],
        userId: json['userId'],
        amountPaid: json['amountPaid'].toDouble(),
        paymentMethod: json['paymentMethod'],
        paymentTime: json['paymentTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'userId': userId,
      'amountPaid': amountPaid,
      'paymentMethod': paymentMethod,
      'paymentTime': paymentTime,
    };
  }
}
