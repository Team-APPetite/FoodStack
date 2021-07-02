import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alerts {
  static Function loseCart() {
    return (BuildContext context) {
      final cartProvider = Provider.of<CartProvider>(context);
      return CupertinoAlertDialog(
        title: const Text('Lose Cart Items'),
        content: const Text(
            'Returning to the previous page will delete all items in your cart'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Add more', style: TextStyles.emphasis()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              cartProvider.clearCart();
            },
            child: Text('Empty cart', style: TextStyles.textButton()),
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
            onPressed: () => Navigator.pop(context),
            child: Text('No', style: TextStyles.emphasis()),
          ),
          TextButton(
            onPressed: () async {
              orderProvider.getOrder(orderProvider.orderId);
              if (orderProvider.cartIds.length > 1) {
                await orderProvider.removeFromCartsList(
                    cartProvider.cartId, orderProvider.orderId);
              } else {
                await orderProvider.removeOrder(orderProvider.orderId);
              }
              await cartProvider.deleteCart(cartProvider.cartId);
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            },
            child: Text('Yes', style: TextStyles.textButton()),
          ),
        ],
      );
    };
  }

  static Function joinOrder() {
    return (BuildContext context) {
      final cartProvider = Provider.of<CartProvider>(context);
      return CupertinoAlertDialog(
        title: const Text('Order Nearby'),
        content: const Text(
            'There is an order nearby from the same restaurant. Would you like to join the order?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();
              pref.setBool('isPooler', true);
              Navigator.pop(context);
            },
            child: Text('Join Order', style: TextStyles.emphasis()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Continue', style: TextStyles.textButton()),
          ),
        ],
      );
    };
  }
}
