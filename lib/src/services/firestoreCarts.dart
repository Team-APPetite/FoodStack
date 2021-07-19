import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FirestoreCarts {
  FirebaseFirestore _db;

  FirestoreCarts({FirebaseFirestore firestore}) {
    if (firestore != null) {
      _db = firestore;
    } else {
      _db = FirebaseFirestore.instance;
    }
  }

  final geo = Geoflutterfire();

  Future<Cart> getCart(String cartId) {
    print("getCart");
    return _db
        .collection('carts')
        .doc(cartId)
        .get()
        .then((snapshot) => Cart.fromJson(snapshot.data()))
        .catchError((error) => null);
  }

  // Create and Update
  Future<void> setCart(Cart cart) {
    var options = SetOptions(merge: true);

    return _db.collection('carts').doc(cart.cartId).set(cart.toMap(), options);
  }

  // Delete
  Future<void> deleteCart(String cartId) {
    return _db.collection('carts').doc(cartId).delete();
  }

  Stream<List<Cart>> getPastOrders(String uid) {
    print("getPastOrders");
    return _db
        .collection('carts')
        .where('userId', isEqualTo: uid)
        .limit(10)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Cart.fromJson(doc.data())).toList());
  }
}
