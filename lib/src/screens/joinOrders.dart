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

class JoinOrdersScreen extends StatefulWidget {
  @override
  _JoinOrdersScreenState createState() => _JoinOrdersScreenState();
}

class _JoinOrdersScreenState extends State<JoinOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final userLocator = Provider.of<UserLocator>(context);
    final geo = Geoflutterfire();

    // TODO Add search bar
    if (userLocator.currentLocation != null) {
      final userLatitude = userLocator.currentLocation.latitude;
      final userLongitude = userLocator.currentLocation.longitude;

      GeoFirePoint center =
          geo.point(latitude: userLatitude, longitude: userLongitude);
      double radius = 250 / 1000; // in kms

      Stream<List<String>> ordersList = orderProvider
          .getNearbyOrdersList(center, radius)
          .map((snapshot) => snapshot
              .map((doc) => Order.fromFirestore(doc.data()))
              .map((e) => e.restaurantId)
              .toList());

      if (ordersList.first != null) {
        return Scaffold(
            appBar: Header.getAppBar(title: 'Join Orders'),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<Restaurant>>(
                  stream:
                      restaurantProvider.nearbyOrderRestaurantsList(ordersList),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
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
                            }),
                      );
                    }
                  }),
            ));
      } else {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    } else {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
