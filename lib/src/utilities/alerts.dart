import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:foodstack/src/models/rating.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/ratingProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/services/notifications.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/time.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Alerts {
  static Function loseCart() {
    return (BuildContext context) {
      final cartProvider = Provider.of<CartProvider>(context);
      final orderProvider = Provider.of<OrderProvider>(context);
      return CupertinoAlertDialog(
        title: const Text('Lose Cart Items'),
        content: const Text(
            'Returning to the previous page will delete all items in your cart'),
        actions: <Widget>[
          TextButton(
            child: Text('Add more', style: TextStyles.emphasis()),
            onPressed: () => Navigator.pop(context, 'Cancel'),
          ),
          TextButton(
            child: Text('Empty cart', style: TextStyles.textButton()),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              cartProvider.clearCart();
              orderProvider.clearOrder();
            },
          ),
        ],
      );
    };
  }

  static Function cancelOrder() {
    return (BuildContext context) {
      final cartProvider = Provider.of<CartProvider>(context);
      final orderProvider = Provider.of<OrderProvider>(context);
      return CupertinoAlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel your order?'),
        actions: <Widget>[
          TextButton(
            child: Text('Go back', style: TextStyles.emphasis()),
            onPressed: () => Navigator.pop(context),
          ),
          Consumer<NotificationService>(
              builder: (context, model, _) => TextButton(
                    child: Text('I\'m sure', style: TextStyles.textButton()),
                    onPressed: () async {
                      await orderProvider.getOrder(orderProvider.orderId);
                      if (orderProvider.cartIds.length > 1) {
                        await orderProvider.removeFromCartsList(
                            cartProvider.cartId, orderProvider.orderId);
                      } else {
                        await orderProvider.removeOrder(orderProvider.orderId);
                      }
                      await cartProvider.deleteCart(cartProvider.cartId);
                      model.cancelNotification();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (r) => false);
                    },
                  )),
        ],
      );
    };
  }

  static Function joinOrder() {
    return (BuildContext context) {
      final orderProvider = Provider.of<OrderProvider>(context);
      final cartProvider = Provider.of<CartProvider>(context);
      final userLocator = Provider.of<UserLocator>(context);
      final geo = Geoflutterfire();
      GeoFirePoint userLocation = geo.point(
          latitude: userLocator.coordinates.latitude,
          longitude: userLocator.coordinates.longitude);
      return Consumer<NotificationService>(
          builder: (context, model, _) => CupertinoAlertDialog(
                title: const Text('Order Nearby'),
                content: const Text(
                    'There is an order nearby from the same restaurant. Would you like to join the order?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Join Order', style: TextStyles.emphasis()),
                    onPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      pref.setBool('isPooler', true);
                      await orderProvider
                          .getNearbyOrder(cartProvider.restaurantId);
                      orderProvider.addToCartsList(
                          cartProvider.cartId, orderProvider.orderId);
                      model.scheduledNotification(
                          TimeHelper.minutesRemaining(orderProvider.orderTime));
                      Navigator.pushNamed(context, '/wait');
                    },
                  ),
                  TextButton(
                    child: Text('No, thanks', style: TextStyles.textButton()),
                    onPressed: () {
                      orderProvider.setOrder(
                          Order(
                              restaurantId: cartProvider.restaurantId,
                              restaurantName: cartProvider.restaurantName,
                              coordinates: userLocation,
                              totalPrice: cartProvider.getSubtotal() +
                                  cartProvider.deliveryFee,
                              deliveryAddress:
                                  userLocator.deliveryAddress.addressLine,
                              cartIds: [cartProvider.cartId]),
                          cartProvider.joinDuration);
                      if (cartProvider.joinDuration != 0)
                        model.scheduledNotification(cartProvider.joinDuration);
                      Navigator.pushNamed(context, '/wait');
                    },
                  ),
                ],
              ));
    };
  }

  static Function provideRating() {
    double newRating = 0.0;
    double averageRating;
    int numOfRatings;

    return (BuildContext context) {
      final restaurantProvider = Provider.of<RestaurantProvider>(context);
      final ratingProvider = Provider.of<RatingProvider>(context);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final authBloc = Provider.of<AuthBloc>(context);
      averageRating = restaurantProvider.rating;
      numOfRatings = restaurantProvider.numOfRatings + 1;
      return CupertinoAlertDialog(
        title: const Text('Leave a review'),
        content: Column(
          children: [
            Text(
                'How was ${restaurantProvider.restaurantName}? Let us know by rating the restaurant!'),
            SizedBox(height: 10.0),
            RatingBar(
              initialRating: 0,
              allowHalfRating: true,
              onRatingUpdate: (rating) {
                newRating = rating;
                print(rating);
              },
              ratingWidget: RatingWidget(
                  full: Icon(
                    Icons.star_rounded,
                    color: ThemeColors.yellows,
                  ),
                  half: Icon(
                    Icons.star_half_rounded,
                    color: ThemeColors.yellows,
                  ),
                  empty: Icon(
                    Icons.star_outline_rounded,
                    color: ThemeColors.yellows,
                  )),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              child: Text('Submit', style: TextStyles.emphasis()),
              onPressed: () {
                //Update rating database and restaurant avg rating
                ratingProvider.addRating(Rating(
                    restaurantId: restaurantProvider.restaurantId,
                    userId: authBloc.user.uid,
                    rating: newRating));
                restaurantProvider.updateNumOfRatings(
                    numOfRatings, restaurantProvider.restaurantId);
                averageRating = ((averageRating * (numOfRatings - 1))+ newRating) / numOfRatings;
                restaurantProvider.updateAverageRating(
                    averageRating, restaurantProvider.restaurantId);
                Navigator.pop(context);
              }),
          TextButton(
            child: Text('Later', style: TextStyles.textButton()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    };
  }
}
