import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/services/notifications.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/utilities/time.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
