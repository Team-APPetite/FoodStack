import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  Stream<List<Restaurant>> favouritesList;

  @override
  void initState() {
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    favouritesList = restaurantProvider.getFavouriteRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);

    return Scaffold(
        appBar: Header.getAppBar(title: 'Your Favourites'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Restaurant>>(
              stream: favouritesList,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.data.length == 0) {
                    return Center(child: Text('Like restaurants to see them here!'));
                  }
                  return Scrollbar(
                    child: RefreshIndicator(
                        color: ThemeColors.greens,
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
                        onRefresh: () {
                          return Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              favouritesList =
                                  restaurantProvider.getFavouriteRestaurants();
                            });
                          });
                        }),
                  );
                }
              }),
        ));
  }
}
