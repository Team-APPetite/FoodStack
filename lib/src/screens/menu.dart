import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/app_providers/menuProvider.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/screens/cart.dart';
import 'package:foodstack/src/screens/details.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
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
  int itemCount = 0;
  var cartItems = [];

  // TODO Add search bar
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    menuProvider.selectRestaurant = widget.restaurantId;

    return Scaffold(
        appBar: Header.getAppBar(title: widget.restaurantName),
        body: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 100.0),
              child: StreamBuilder<List<FoodItem>>(
                  stream: menuProvider.menu,
                  builder: (context, snapshot) {
                    return (snapshot.data == null)
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              // TODO Update food card and add search bar
                              return FoodCard(
                                  snapshot.data[index].foodName,
                                  snapshot.data[index].price,
                                  snapshot.data[index].image, () {
                                menuProvider.loadFoodItem(
                                    widget.restaurantId, snapshot.data[index]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsScreen(menuProvider)));
                              }, () {
                                setState(() {
                                  cartItems.add(1);
                                  cartItems[itemCount] = snapshot.data[index];
                                  itemCount++;
                                });
                              });
                            });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppButton(
                        buttonText: 'VIEW CART',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen(cartItems)));
                        },
                      ),
                      Stack(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 60,
                            color: ThemeColors.yellows,
                          ),
                          Positioned(
                              bottom: 14,
                              left: (itemCount < 10) ? 25 : 20,
                              child: Text(
                                '$itemCount',
                                style: TextStyles.heading3(),
                              ))
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ));
  }
}
