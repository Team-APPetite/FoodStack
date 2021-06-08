import 'package:foodstack/src/app_providers/restaurantProvider.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// TODO Can probably do without stful widget?
// Use the code in this file to add data to cloud firestore
// from the newOrder screen

class Restaurants extends StatefulWidget {
  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);

    restaurantProvider.addRestaurant(Restaurant(
        restaurantName: 'Fat Boy\'s The Burger Bar',
        cuisineType: 'Fast Food',
        deliveryMins: '38',
        rating: 4,
        image:
        'https://thesmartlocal.com/reviews/wp-content/uploads/2012/05/fat-1336894297.jpg'));

    return Container();
  }


}
