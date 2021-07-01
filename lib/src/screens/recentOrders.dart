import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
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
    _getPastOrders();
  }


  Future<void> _getPastOrders() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final restaurantProvider =
    Provider.of<RestaurantProvider>(context, listen: false);

    if (auth.currentUser != null) {
      restaurantProvider.loadPastOrdersRestaurantsList(
          cartProvider.getRestaurantsfromPastOrders(auth.currentUser.toString()));
    } else {
      loading = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context);

    // TODO Add search bar
    // final uid = FirebaseAuth.instance.currentUser.toString();
    // Stream<List<DocumentSnapshot<Object>>> pastOrders =
    // cartProvider.getPastOrdersList(uid);
    //
    // Stream<List<Order>> orders = pastOrders.map((snapshot) =>
    //     snapshot.map((doc) => Order.fromFirestore(doc.data())).toList());
    //
    // Stream<List<String>> restaurantIds = pastOrders.map((snapshot) =>
    //     snapshot
    //         .map((doc) => Order.fromFirestore(doc.data()))
    //         .map((e) => e.restaurantId)
    //         .toList());

    // restaurantProvider.loadPastOrdersRestaurantsList(restaurantIds);

    if (!loading) {
    return Scaffold(
        appBar: Header.getAppBar(title: 'Recent Orders'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Restaurant>>(
              stream: restaurantProvider
                  .getPastOrdersRestaurantsList(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: Text(
                          'You have no past orders!'));
                } else {
                  return Scrollbar(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return RestaurantCard(
                                snapshot.data[index].restaurantId,
                                snapshot.data[index].restaurantName,
                                snapshot.data[index].cuisineType,
                                snapshot.data[index].deliveryFee,
                                snapshot.data[index].rating,
                                snapshot.data[index].image);
                          }));
                }
              }),
        ));
    } else {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
