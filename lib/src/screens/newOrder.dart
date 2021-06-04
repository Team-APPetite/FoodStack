import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/admin/restaurants.dart';
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
    final restaurants = Restaurants();
    return Scaffold(
        appBar: Header.getAppBar(title: 'Start a New Order'),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Restaurant>>(
              stream: restaurantProvider.restaurantsList,
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      // TODO Update restaurant card and add search bar
                      return RestaurantCard(
                          restaurant: new Restaurant(
                              restaurantId: snapshot.data[index].restaurantId,
                              restaurantName: snapshot.data[index].restaurantName,
                              cuisineType: snapshot.data[index].cuisineType,
                              deliveryMins: snapshot.data[index].deliveryMins,
                              rating: snapshot.data[index].rating,
                              image:
                              snapshot.data[index].image));
                      //   Column(
                      //   children: [
                      //     // TODO Search for restaurants
                      //     Padding(
                      //       padding: const EdgeInsets.all(16.0),
                      //       child: CupertinoSearchTextField(
                      //         padding: EdgeInsets.all(15.0),
                      //       ),
                      //     ),
                      //     RestaurantCard(
                      //         restaurant: new Restaurant(
                      //             restaurantId: '123',
                      //             restaurantName: 'Mc Donald\'s',
                      //             cuisineType: 'Fast Food',
                      //             deliveryMins: '25',
                      //             rating: 3,
                      //             image:
                      //                 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png')),
                      //     RestaurantCard(
                      //         restaurant: new Restaurant(
                      //             restaurantId: '123',
                      //             restaurantName: 'Mc Donald\'s',
                      //             cuisineType: 'Fast Food',
                      //             deliveryMins: '25',
                      //             rating: 3,
                      //             image:
                      //                 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png')),
                      //     RestaurantCard(
                      //         restaurant: new Restaurant(
                      //             restaurantId: '123',
                      //             restaurantName: 'Mc Donald\'s',
                      //             cuisineType: 'Fast Food',
                      //             deliveryMins: '25',
                      //             rating: 3,
                      //             image:
                      //                 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png')),
                      //     RestaurantCard(
                      //         restaurant: new Restaurant(
                      //             restaurantId: '123',
                      //             restaurantName: 'Mc Donald\'s',
                      //             cuisineType: 'Fast Food',
                      //             deliveryMins: '25',
                      //             rating: 3,
                      //             image:
                      //                 'https://seeklogo.com/images/M/mcdonald-s-logo-255A7B5646-seeklogo.com.png')),
                      //   ],
                      // );
                    });
              }),
        ));
  }
}
