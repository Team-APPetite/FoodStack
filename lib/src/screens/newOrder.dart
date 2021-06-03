import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/restaurantCard.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(title: 'Start a New Order'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            RestaurantCard(restaurant: new Restaurant(restaurantId: '123', restaurantName: 'Mc Donald\'s', cuisineType: 'Fast Food', deliveryMins: '25', rating: 3, image: 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png')),
            RestaurantCard(restaurant: new Restaurant(restaurantId: '123', restaurantName: 'Mc Donald\'s', cuisineType: 'Fast Food', deliveryMins: '25', rating: 3, image: 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png')),
            RestaurantCard(restaurant: new Restaurant(restaurantId: '123', restaurantName: 'Mc Donald\'s', cuisineType: 'Fast Food', deliveryMins: '25', rating: 3, image: 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png')),
            RestaurantCard(restaurant: new Restaurant(restaurantId: '123', restaurantName: 'Mc Donald\'s', cuisineType: 'Fast Food', deliveryMins: '25', rating: 3, image: 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png')),
          ],
        ),
      ),
    );
  }
}
