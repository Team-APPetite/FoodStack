import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:geoflutterfire/geoflutterfire.dart';


class FirestoreCarts {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final geo = Geoflutterfire();


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


  Stream<List<DocumentSnapshot>> getPastOrders(String uid){
    return _db
            .collection('carts')
            .where('userId', isEqualTo: uid)
            .limit(10)
            .snapshots()
            .map((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
             return querySnapshot.docs.toList();
    });
  }

  Future<Cart> getPastOrder(String uid) {
    return  _db
            .collection('carts')
            .where('userId', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      return querySnapshot.docs.toList();
    })
        .map((snapshot) =>
    snapshot.map((doc) => Cart.fromJson(doc.data())).first).first;

  }

  // Delete
  Future<void> deleteCart(String cartId) {
    return _db.collection('carts').doc(cartId).delete();
  }
}
