import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/models/cart.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:provider/provider.dart';

class FoodCard extends StatefulWidget {
  final String foodId;
  final String foodName;
  final String description;
  final double price;
  final String image;
  final String restaurantId;

  FoodCard(
    this.foodId,
    this.foodName,
    this.description,
    this.price,
    this.image,
    this.restaurantId,
  );

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    int quantity = cartProvider.getItemQuantityOf(widget.foodId);

    return Stack(
      children: [
        TextButton(
          key: Key("foodCard_${widget.foodName}"),
          onPressed: () {
            menuProvider.loadFoodItem(
                widget.restaurantId,
                FoodItem(
                    foodId: widget.foodId,
                    foodName: widget.foodName,
                    description: widget.description,
                    price: widget.price,
                    image: widget.image));
            Navigator.pushNamed(context, '/details');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              margin: const EdgeInsets.only(
                  bottom: 3.0, right: 2.0, top: 1.0, left: 2.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.light,
                    offset: Offset(0.0, 2.0), //(x,y)
                    blurRadius: 3.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: ThemeColors.light,
                  width: 0.5,
                ),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: widget.image.isNotEmpty
                            ? Container(
                                child: Image.network(
                                widget.image,
                                fit: BoxFit.cover,
                              ))
                            : Container(),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 8.0),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    widget.foodName,
                                    textAlign: TextAlign.center,
                                    style: TextStyles.heading3(),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '\$' + widget.price.toString(),
                                  style: TextStyles.emphasis(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              key: Key("addButton_${widget.foodName}"),
              child: Icon(Icons.add),
              mini: true,
              elevation: 2,
              heroTag: null,
              onPressed: () {
                cartProvider.addToCart(CartItem(
                    foodId: widget.foodId,
                    foodName: widget.foodName,
                    image: widget.image,
                    price: widget.price,
                    quantity: 1,
                    notes: 'none'));
              },
              backgroundColor: ThemeColors.mint,
              splashColor: ThemeColors.oranges,
            )),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: Align(
            alignment: Alignment.topLeft,
            child: quantity > 0
                ? Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'x' + quantity.toString(),
                        style: TextStyles.textButton(),
                      ),
                    ))
                : Container(),
          ),
        )
      ],
    );
  }
}
