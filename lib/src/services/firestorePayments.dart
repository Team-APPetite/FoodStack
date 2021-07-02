import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/payment.dart';

class FirestorePayments {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  
  Stream<List<Payment>> getPayments(String userId) {
     return _db
            .collection('payments')
            .where('userId', isEqualTo: userId)
            .snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Payment.fromJson(doc.data())).toList());
  }

  Future<void> addPayment(Payment payment) {
     var options = SetOptions(merge: true);

    return _db
        .collection('payments')
        .doc(payment.paymentId)
        .set(payment.toMap(), options);
  }
}

