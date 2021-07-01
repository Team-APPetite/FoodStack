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
    _getNearbyOrders();
  }

  Future<void> _setUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPooler', true);
  }

  Future<void> _getNearbyOrders() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    final userLocator = Provider.of<UserLocator>(context, listen: false);

    if (userLocator.coordinates != null) {
      restaurantProvider.loadNearbyOrdersRestaurantsList(
          orderProvider.getRestaurantsfromOrders(userLocator.coordinates));
    } else {
      loading = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    if (!loading) {
      // TODO Add search bar
      return Scaffold(
          appBar: Header.getAppBar(title: 'Join Orders'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Restaurant>>(
                stream: restaurantProvider.getNearbyOrdersRestaurantsList(),
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
