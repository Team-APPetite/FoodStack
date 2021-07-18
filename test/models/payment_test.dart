import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/models/payment.dart';

Timestamp currentTime = Timestamp.now();
Payment mockPayment = Payment(
    paymentId: "123",
    orderId: "456",
    userId: "789",
    amountPaid: 13.40,
    paymentMethod: "Pay online",
    paymentTime: currentTime);

var jsonPayment = {
  "paymentId": "123",
  "orderId": "456",
  "userId": "789",
  "amountPaid": 13.40,
  "paymentMethod": "Pay online",
  "paymentTime": currentTime
};

void main() async {
  group('Payment model', () {
    test('From json', () {
      Payment payment = Payment.fromJson(jsonPayment);
      expect(payment.paymentId, mockPayment.paymentId);
      expect(payment.orderId, mockPayment.orderId);
      expect(payment.userId, mockPayment.userId);
      expect(payment.amountPaid, mockPayment.amountPaid);
      expect(payment.paymentMethod, mockPayment.paymentMethod);
      expect(payment.paymentTime, mockPayment.paymentTime);
    });

    test('To map', () {
      expect(mockPayment.toMap(), jsonPayment);
    });
  });
}
