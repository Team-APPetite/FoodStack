import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/screens/cart.dart';
import 'package:foodstack/src/screens/details.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/foodCard.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final double deliveryFee;

  MenuScreen({this.restaurantId, this.restaurantName, this.deliveryFee});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var cartItems = [];

  // TODO Add search bar
  // TODO Add restaurant image by putting GridView in column(expanded())
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    menuProvider.selectRestaurant = widget.restaurantId;
    cartProvider.deliveryFee = widget.deliveryFee;
    cartProvider.restaurantId = widget.restaurantId;

    Widget viewCart() {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.light,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
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
                            builder: (_) => ChangeNotifierProvider.value(
                              value: cartProvider,
                              child: CartScreen(),
                            ),
                          ));
                    },
                  ),
                  cartProvider.itemQuantityIcon(),
                ],
              ),
            ),
          ));
    }

    return Scaffold(
        appBar: Header.getAppBar(
          title: widget.restaurantName,
          alert: cartProvider.itemCount > 0 ? 'loseCart' : 'none',
        ),
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
                        : Scrollbar(
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) =>
                                  ChangeNotifierProvider.value(
                                      value: cartProvider,
                                      child: FoodCard(
                                          snapshot.data[index].foodId,
                                          snapshot.data[index].foodName,
                                          snapshot.data[index].price,
                                          snapshot.data[index].image, () {
                                        menuProvider.loadFoodItem(
                                            widget.restaurantId,
                                            snapshot.data[index]);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsScreen(
                                                        menuProvider)));
                                      })),
                            ),
                        );
                  }),
            ),
            viewCart(),
          ],
        ));
  }
}
