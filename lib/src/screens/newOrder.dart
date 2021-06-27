import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
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
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final userLocator = Provider.of<UserLocator>(context);

    // TODO Add search bar
    return Scaffold(
        appBar: Header.getAppBar(title: 'Start a New Order'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Restaurant>>(
              stream: restaurantProvider.restaurantsList,
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    userLocator.coordinates == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final userLatitude = userLocator.coordinates.latitude;
                  final userLongitude = userLocator.coordinates.longitude;
                  snapshot.data.sort((a, b) => Geolocator.distanceBetween(
                          a.coordinates.latitude,
                          a.coordinates.longitude,
                          userLatitude,
                          userLongitude)
                      .compareTo(Geolocator.distanceBetween(
                          b.coordinates.latitude,
                          b.coordinates.longitude,
                          userLatitude,
                          userLongitude)));
                  return Scrollbar(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          // TODO Update restaurant card
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
  }
}
