import 'package:flutter/material.dart';
import 'package:foodstack/src/widgets/header.dart';

class CartScreen extends StatefulWidget {
  final List cartItems;

  const CartScreen(this.cartItems);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.getAppBar(title: 'View Cart'),
        body: Center(
          child: Text(
            '${widget.cartItems[0].foodName}',
            textAlign: TextAlign.center,
          ),
        ));
  }
}
