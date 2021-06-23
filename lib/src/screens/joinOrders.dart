import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinOrdersScreen extends StatefulWidget {
  @override
  _JoinOrdersScreenState createState() => _JoinOrdersScreenState();
}

class _JoinOrdersScreenState extends State<JoinOrdersScreen> {
  @override
  void initState() {
    super.initState();
    _setUserRole();
  }

  Future<void> _setUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPooler', true);
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final userLocator = Provider.of<UserLocator>(context);
    final geo = Geoflutterfire();
    String orderId;

    // TODO Add search bar
    if (userLocator.currentLocation != null) {
      final userLatitude = userLocator.currentLocation.latitude;
      final userLongitude = userLocator.currentLocation.longitude;

      GeoFirePoint center =
          geo.point(latitude: userLatitude, longitude: userLongitude);
      double radius = 250 / 1000; // in kms

      Stream<List<DocumentSnapshot<Object>>> nearbyOrders =
          orderProvider.getNearbyOrdersList(center, radius);

      Stream<List<Order>> orders = nearbyOrders.map((snapshot) =>
          snapshot.map((doc) => Order.fromFirestore(doc.data())).toList());

      Stream<List<String>> restaurantIds = nearbyOrders.map((snapshot) =>
          snapshot
              .map((doc) => Order.fromFirestore(doc.data()))
              .map((e) => e.restaurantId)
              .toList());

      restaurantProvider.loadNearbyOrderRestaurantsList(restaurantIds);

      return Scaffold(
          appBar: Header.getAppBar(title: 'Join Orders'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Restaurant>>(
                stream: restaurantProvider
                    .loadNearbyOrderRestaurantsList(restaurantIds),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                        child: Text(
                            'Check another time! No nearby orders right now'));
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
