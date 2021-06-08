import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/styles/themeColors.dart';

class FoodCard extends StatefulWidget {
  final String foodName;
  final double price;
  final String image;

  FoodCard(this.foodName, this.price, this.image);

  @override
  _FoodCardState createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Container(
        height: 700.0,
        width: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: ThemeColors.light,
            width: 1,
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Image.network(widget.image),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.foodName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),

                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '\$' + widget.price.toString(),
                  style: TextStyle(
                    color: ThemeColors.mint,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
