import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/screens/menu.dart';
import 'package:foodstack/src/styles/themeColors.dart';

// Will update UI later

class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantCard({this.restaurant});

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MenuScreen(restaurant: widget.restaurant,)));
      },
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: ThemeColors.light,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Expanded(
              flex: 2,
              child: Image.network(widget.restaurant.image),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurant.restaurantName,
                      style: TextStyle(
                        color: ThemeColors.dark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                        widget.restaurant.cuisineType,
                      style: TextStyle(
                        color: ThemeColors.mint,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      children: [
                        Icon(
                            Icons.star_rounded,
                        color: ThemeColors.yellows,),
                        Icon(
                          Icons.star_rounded,
                          color: ThemeColors.yellows,),
                        Icon(
                          Icons.star_rounded,
                          color: ThemeColors.yellows,),
                        Icon(
                          Icons.star_half_rounded,
                          color: ThemeColors.yellows,),
                        Icon(
                          Icons.star_outline_rounded,
                          color: ThemeColors.yellows,),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.pinkAccent,
                    size: 30.0,
                  ),
                  Text(
                      widget.restaurant.deliveryMins + ' mins',
                    style: TextStyle(
                      color: ThemeColors.mint,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              )
            ),
          ]),
        ),
      ),
    );
  }
}
