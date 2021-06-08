import 'package:flutter/material.dart';
import 'package:foodstack/src/app_providers/menuProvider.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/widgets/foodCard.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  MenuScreen({this.restaurantId, this.restaurantName});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  // TODO Add search bar
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    menuProvider.selectRestaurant = widget.restaurantId;
    // menuProvider.addFoodItem(widget.restaurantId, FoodItem(
    //       foodName: 'Chicken McNuggets (20pc)',
    //       description: '20 crispy chicken nuggets fried in sunflower oil.',
    //       price: 13.60,
    //       image: 'https://www.mcdelivery.com.sg/sg/static/1623068177388/assets/65/products/101900.png?'));

    return Scaffold(
        appBar: Header.getAppBar(title: widget.restaurantName),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<FoodItem>>(
              stream: menuProvider.menu,
              builder: (context, snapshot) {
                return (snapshot.data == null)
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      // TODO Update food card and add search bar
                      return FoodCard(
                          snapshot.data[index].foodName,
                          snapshot.data[index].price,
                          snapshot.data[index].image
                      );
                    });
              }),
        ));
  }
}
