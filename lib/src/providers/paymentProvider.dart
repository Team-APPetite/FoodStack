import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/models/payment.dart';
import 'package:foodstack/src/services/firestorePayments.dart';
import 'package:uuid/uuid.dart';

class PaymentProvider with ChangeNotifier {
  final firestoreService = FirestorePayments();
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _paymentId;
  String _orderId;
  String _userId;
  double _amountPaid;
  String _paymentMethod;
  Timestamp _paymentTime;

  String get paymentMethod => _paymentMethod;

  addPayment(String orderId, double amountPaid, String paymentMethod) {
    var uuid = Uuid();
    _paymentId = uuid.v1();
    _orderId = orderId;
    _userId = _auth.currentUser.uid;
    _amountPaid = amountPaid;
    _paymentMethod = paymentMethod;
    _paymentTime = Timestamp.now();

    var payment = Payment(
        paymentId: _paymentId,
        orderId: _orderId,
        userId: _userId,
        amountPaid: _amountPaid,
        paymentMethod: _paymentMethod,
        paymentTime: _paymentTime);
    firestoreService.addPayment(payment);
  }
}
