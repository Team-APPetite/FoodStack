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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: ThemeColors.light,
                width: 1,
              ),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: widget.image.isNotEmpty ? Image.network(widget.image) : Container(),
                      ),
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
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              key: Key("addButton_${widget.foodName}"),
              child: Icon(Icons.add),
              mini: true,
              elevation: 0,
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
          padding: const EdgeInsets.only(top: 20, left: 15),
          child: Align(
            alignment: Alignment.topLeft,
            child: quantity > 0
                ? Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ' x' + quantity.toString(),
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
