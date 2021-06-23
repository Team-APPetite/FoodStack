import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:provider/provider.dart';

class Alerts {
  static Function loseCart() {
    return (BuildContext context) {
      final cartProvider = Provider.of<CartProvider>(context);
      return AlertDialog(
        buttonPadding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        title: const Text('Lose Cart Items'),
        content: const Text(
            'Returning to the previous page will delete all items in your cart'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('Add more items', style: TextStyles.emphasis()),
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
}