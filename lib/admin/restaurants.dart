import 'package:foodstack/src/app_providers/restaurantProvider.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// TODO Can probably do without stful widget?

class Restaurants extends StatefulWidget {
  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);

    restaurantProvider.loadRestaurant(Restaurant(
        restaurantId: '11100',
        restaurantName: 'KFC',
        cuisineType: 'Fast Food',
        deliveryMins: '35',
        rating: 4,
        image:
        'https://upload.wikimedia.org/wikipedia/sco/thumb/b/bf/KFC_logo.svg/1200px-KFC_logo.svg.png'));

    restaurantProvider.addRestaurant();

    return Container();
  }


}
