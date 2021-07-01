import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// Can probably do without stful widget?

// Use the code in this file to add data to cloud firestore
// 1) Restaurants from the NewOrderScreen
// 2) FoodItems from the MenuScreen

class MockData extends StatefulWidget {
  final String restaurantId = ''; // to suppress error
  @override
  _MockDataState createState() => _MockDataState();
}

class _MockDataState extends State<MockData> {
  @override
  Widget build(BuildContext context) {

    // 1)
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    // ignore: missing_required_param
    restaurantProvider.addRestaurant(Restaurant(
        restaurantName: 'Fat Boy\'s The Burger Bar',
        cuisineType: 'Fast Food',
        deliveryFee: 6,
        rating: 4,
        image:
            'https://thesmartlocal.com/reviews/wp-content/uploads/2012/05/fat-1336894297.jpg',
        coordinates: GeoPoint(1, 1))); // (latitude, longitude)

    // 2)
    final menuProvider = Provider.of<MenuProvider>(context);
    menuProvider.addFoodItem(
        widget.restaurantId,
        // ignore: missing_required_param
        FoodItem(
            foodName: 'Chicken McNuggets (20pc)',
            description: '20 crispy chicken nuggets fried in sunflower oil.',
            price: 13.60,
            image:
                'https://www.mcdelivery.com.sg/sg/static/1623068177388/assets/65/products/101900.png?'));

    return Container();
  }
}
