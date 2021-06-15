import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/cart.dart';

class FirestoreCarts {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Cart> getCart(String cartId) {
    return _db
        .collection('carts')
        .doc(cartId)
        .get()
        .then((snapshot) => Cart.fromJson(snapshot.data()));
  }

  // Create and Update
  Future<void> setCart(Cart cart) {
    var options = SetOptions(merge: true);

    return _db
        .collection('carts')
        .doc(cart.cartId)
        .set(cart.toMap(), options);
  }

  // Delete
  Future<void> removeCart(String cartId) {
    return _db.collection('carts').doc(cartId).delete();
  }
}
