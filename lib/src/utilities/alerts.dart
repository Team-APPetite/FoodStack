import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  static int noOfSecondsPerMinute = 60;

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
            onPressed: () => Navigator.pop(context),
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

  static Function orderClosed() {
    return (BuildContext context) {
      final cartProvider = Provider.of<CartProvider>(context);
      return CupertinoAlertDialog(
        title: const Text('Order closed'),
        content: const Text('Sorry but the order has already closed'),
        actions: <Widget>[
          TextButton(
            child: Text('Go home', style: TextStyles.emphasis()),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
              cartProvider.clearCart();
            },
          ),
          TextButton(
            child: Text('New order', style: TextStyles.textButton()),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
              Navigator.pushNamed(context, '/newOrder');
              cartProvider.clearCart();
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
                      model.scheduledNotification(TimeHelper.secondsRemaining(
                          orderProvider.orderTime, DateTime.now()));
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
                        model.scheduledNotification(
                            cartProvider.joinDuration * noOfSecondsPerMinute);
                      Navigator.pushNamed(context, '/wait');
                    },
                  ),
                ],
              ));
    };
  }

  static Function provideRating() {
    double newRating = 0.0;

    return (BuildContext context) {
      final restaurantProvider = Provider.of<RestaurantProvider>(context);
      final ratingProvider = Provider.of<RatingProvider>(context);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final authBloc = Provider.of<AuthBloc>(context);
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
            child: Text('Later', style: TextStyles.textButton()),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
              child: Text('Submit', style: TextStyles.emphasis()),
              onPressed: () {
                //Update rating database and restaurant avg rating
                ratingProvider.addRating(Rating(
                    restaurantId: restaurantProvider.restaurantId,
                    userId: authBloc.user.uid,
                    rating: newRating));
                restaurantProvider.addRating(
                    restaurantProvider.restaurantId, newRating);

                orderProvider.setStatusAsNone(orderProvider.orderId);

                Navigator.pop(context);

                Fluttertoast.showToast(
                  msg: 'Thank you for your review!',
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: ThemeColors.dark,
                );
              }),
        ],
      );
    };
  }

  static Function noInternet() {
    return (BuildContext context) {
      return CupertinoAlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline_rounded),
            const Text('  No internet connection'),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
              'Your device is currently offline. Please check your internet connection and try again.'),
        ),
      );
    };
  }
}
