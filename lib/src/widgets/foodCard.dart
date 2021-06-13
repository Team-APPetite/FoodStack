import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';

class FoodCard extends StatefulWidget {
  final String foodName;
  final double price;
  final String image;
  final void Function() onPressedDetails;
  final void Function() onPressedCart;

  FoodCard(this.foodName, this.price, this.image, this.onPressedDetails,
      this.onPressedCart);

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextButton(
          onPressed: widget.onPressedDetails,
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
                        child: Image.network(widget.image),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.foodName,
                          textAlign: TextAlign.center,
                          style: TextStyles.heading3(),
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
              child: quantity == 0
                  ? Icon(Icons.add)
                  : Text(quantity.toString(), style: TextStyle(fontSize: 16.0)),
              mini: true,
              elevation: 0,
              heroTag: null,
              onPressed: widget.onPressedCart,
              backgroundColor: ThemeColors.mint,
              splashColor: ThemeColors.oranges,
            ))
      ],
    );
  }
}
