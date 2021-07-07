import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
  final restaurantProvider = Provider.of<RestaurantProvider>(context);

    // TODO Add search bar
    return Scaffold(
        appBar: Header.getAppBar(title: 'Your Favourites'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Restaurant>>(
              stream: restaurantProvider.getFavouriteRestaurants(),
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
                              snapshot.data[index].image,
                              favourite: true);
                        }),
                  );
                }
              }),
        ));
  }
}
