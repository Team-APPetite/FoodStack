import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/pastOrderCard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentOrdersScreen extends StatefulWidget {
  @override
  _RecentOrdersScreenState createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen> {
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _setUserRole();
  }

  Future<void> _setUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPooler', false);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    String uid;
    if (auth.currentUser != null) {
      uid = auth.currentUser.uid;
    }

    return Scaffold(
        appBar: Header.getAppBar(title: 'Place Orders Again'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Cart>>(
              stream: cartProvider.getRecentCartsList(uid),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  print(cartProvider.getRecentCartsList(uid).toList());
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.data.length == 0) {
                    return Center(
                        child: Text('Place orders to see them here!'));
                  }
                  return Scrollbar(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            Cart cart = snapshot.data[index];
                            return PastOrderCard(
                                cart.cartId,
                                cart.cartItems,
                                cart.restaurantId,
                                cart.restaurantName,
                                cart.subtotal,
                                cart.deliveryFee);
                          }));
                }
              }),
        ));
  }
}
