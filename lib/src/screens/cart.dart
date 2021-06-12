import 'package:flutter/material.dart';
import 'package:foodstack/src/styles/textStyles.dart';
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
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    return _cartItem(widget.cartItems[index].foodName,
                        '\$' + widget.cartItems[index].price.toString(),
                        widget.cartItems[index].image);
                  })),

        ],
      ),
    );
  }
}

Widget _cartItem(String name, String price, String image) {
  return Container(
    height: 80,
    child: Row(

      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text(name,
              style: TextStyles.heading3()),
              Text(price),
              // counter
            ],
          ),
        ),

        Expanded(flex: 1, child: Image.network(image))
      ],
    ),
  );
}


