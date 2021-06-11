import 'package:flutter/material.dart';
import 'package:foodstack/src/screens/menu.dart';
import 'package:foodstack/src/styles/themeColors.dart';

// Will update UI and modularize later

class RestaurantCard extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String cuisineType;
  final String deliveryMins;
  final double rating;
  final String image;

  RestaurantCard(
      this.restaurantId,
      this.restaurantName,
      this.cuisineType,
      this.deliveryMins,
      this.rating,
      this.image);

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuScreen(
                  restaurantId: widget.restaurantId,
                      restaurantName: widget.restaurantName,
                    )));
      },
      child: Container(
        height: 130.0,
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
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
              flex: 4,
              child: Image.network(widget.image),
            ),
            Expanded(
              flex: 11,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurantName,
                      style: TextStyle(
                        color: ThemeColors.dark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      widget.cuisineType,
                      style: TextStyle(
                        color: ThemeColors.teals,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: ThemeColors.yellows,
                        ),
                        Icon(
                          Icons.star_rounded,
                          color: ThemeColors.yellows,
                        ),
                        Icon(
                          Icons.star_rounded,
                          color: ThemeColors.yellows,
                        ),
                        Icon(
                          Icons.star_half_rounded,
                          color: ThemeColors.yellows,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: ThemeColors.oranges,
                      size: 30.0,
                    ),
                    Text(
                      widget.deliveryMins + ' mins',
                      style: TextStyle(
                        color: ThemeColors.teals,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
