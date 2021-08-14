import 'package:flutter/material.dart';
import 'package:foodstack/src/models/restaurant.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';

// ignore: must_be_immutable
class RestaurantCard extends StatefulWidget {
  final String keyString;
  final String restaurantId;
  final String restaurantName;
  final String cuisineType;
  final double deliveryFee;
  final double rating;
  final String image;
  bool favourite = false;

  RestaurantCard(this.keyString, this.restaurantId, this.restaurantName, this.cuisineType,
      this.deliveryFee, this.rating, this.image,
      {this.favourite = false});

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    final FirestoreUsers firestoreService = FirestoreUsers();

    return TextButton(
      key: Key(widget.keyString),
      onPressed: () {
        Navigator.pushNamed(context, '/menu', arguments: {
          'restaurantId': widget.restaurantId,
          'restaurantName': widget.restaurantName,
          'deliveryFee': widget.deliveryFee,
          'image': widget.image,
        });
      },
      child: Container(
        height: 130.0,
        margin:
            const EdgeInsets.only(bottom: 3.0, right: 2.0, top: 1.0, left: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: ThemeColors.light,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.light,
              offset: Offset(0.0, 2.0), //(x,y)
              blurRadius: 3.0,
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
              flex: 1,
              child: widget.image.isNotEmpty
                  ? Image.network(widget.image)
                  : Container(),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurantName,
                      style: TextStyles.heading3(),
                    ),
                    Text(
                      widget.cuisineType,
                      style: TextStyles.details(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < widget.rating.toInt(); i++)
                          Icon(
                            Icons.star_rounded,
                            color: ThemeColors.yellows,
                          ),
                        if (widget.rating % 1 >= 0.75)
                          Icon(
                            Icons.star_rounded,
                            color: ThemeColors.yellows,
                          ),
                        if (widget.rating % 1 >= 0.25 &&
                            widget.rating % 1 < 0.75)
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: widget.favourite
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: ThemeColors.light,
                            ),
                      iconSize: 30.0,
                      onPressed: () {
                        setState(() {
                          widget.favourite = !widget.favourite;
                          widget.favourite
                              ? firestoreService.addToFavourites(Restaurant(
                                  restaurantId: widget.restaurantId,
                                  restaurantName: widget.restaurantName,
                                  cuisineType: widget.cuisineType,
                                  deliveryFee: widget.deliveryFee,
                                  rating: widget.rating,
                                  image: widget.image))
                              : firestoreService.removeFromFavourites(
                                  Restaurant(
                                      restaurantId: widget.restaurantId,
                                      restaurantName: widget.restaurantName,
                                      cuisineType: widget.cuisineType,
                                      deliveryFee: widget.deliveryFee,
                                      rating: widget.rating,
                                      image: widget.image));
                        });
                      },
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.delivery_dining,
                          color: ThemeColors.teals,
                          size: 20,
                        ),
                        Text(
                          '\$${widget.deliveryFee}',
                          style: TextStyles.details(),
                        ),
                      ],
                    ),
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
