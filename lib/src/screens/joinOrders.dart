import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:provider/provider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinOrdersScreen extends StatefulWidget {
  @override
  _JoinOrdersScreenState createState() => _JoinOrdersScreenState();
}

class _JoinOrdersScreenState extends State<JoinOrdersScreen> {
  bool loading = false;

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
    final userLocator = Provider.of<UserLocator>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    return Scaffold(
        appBar: Header.getAppBar(title: 'Join Orders'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<String>>(
              stream: orderProvider
                  .getRestaurantsfromOrders(userLocator.coordinates),
              builder: (context1, snapshot1) {
                if (snapshot1.data == null) {
                  return Center(
                      child: Text(
                          'Check another time! No nearby orders right now'));
                } else {
                  return StreamBuilder<List<Restaurant>>(
                    stream: restaurantProvider
                        .loadNearbyOrdersRestaurantsList(snapshot1.data),
                    builder: (context2, snapshot2) {
                      if (snapshot2.data == null
                          ? true
                          : snapshot2.data.length == 1
                              ? restaurantProvider
                                      .loadNearbyOrdersRestaurantsList(
                                          snapshot1.data) == null
                              : false) {
                        return Center(
                            child: Text(
                                'Check another time! No nearby orders right now'));
                      } else {
                        return Scrollbar(
                            child: ListView.builder(
                                itemCount: snapshot2.data.length,
                                itemBuilder: (context, index) {
                                  return RestaurantCard(
                                      snapshot2.data[index].restaurantId,
                                      snapshot2.data[index].restaurantName,
                                      snapshot2.data[index].cuisineType,
                                      snapshot2.data[index].deliveryFee,
                                      snapshot2.data[index].rating,
                                      snapshot2.data[index].image);
                                }));
                      }
                    },
                  );
                }
              }),
        ));
  }
}
