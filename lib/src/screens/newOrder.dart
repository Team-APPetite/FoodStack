import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:foodstack/src/app_providers/restaurantProvider.dart';
import 'package:provider/provider.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);

    return Scaffold(
        appBar: Header.getAppBar(title: 'Start a New Order', search: true),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Restaurant>>(
              stream: restaurantProvider.restaurantsList,
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      // TODO Update restaurant card and add search bar
                      return (snapshot.data == null)
                          ? Center(child: CircularProgressIndicator())
                          : RestaurantCard(
                              snapshot.data[index].restaurantName,
                              snapshot.data[index].cuisineType,
                              snapshot.data[index].deliveryMins,
                              snapshot.data[index].rating,
                              snapshot.data[index].image);
                    });
              }),
        ));
  }
}
