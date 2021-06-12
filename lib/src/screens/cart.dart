import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:collection/collection.dart';

class CartScreen extends StatefulWidget {
  final List cartItems;

  const CartScreen(this.cartItems);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartList;
  List quantity;

  @override
  Widget build(BuildContext context) {
    cartList = groupBy(widget.cartItems, (e) => e.foodId)
        .values
        .map((e) => e[0])
        .toList();
    quantity = groupBy(widget.cartItems, (e) => e.foodId)
        .values
        .map((e) => e.length)
        .toList();
    return Scaffold(
      appBar: Header.getAppBar(title: 'View Cart'),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    return _cartItem(
                        cartList[index].foodName,
                        '\$' + cartList[index].price.toString(),
                        cartList[index].image,
                        index,
                    quantity[index]);
                  })),
        ],
      ),
    );
  }

  Widget _cartItem(String name, String price, String image, int index, int init) {
    if (quantity[index] == 0) {
      print('if');
      print(quantity[index]);
      return Text('Hi');
    } else {
      print('else');
      print(quantity[index]);
      return Container(
        height: 100,
        child: Row(
          children: [
            Expanded(flex: 1, child: Image.network(image)),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(name, style: TextStyles.heading3()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: TextStyles.emphasis(),
                      ),
                      CustomNumberPicker(
                          onValue: (value) {
                            setState(() {
                              quantity[index] = value;
                              print('set');
                              print(quantity[index]);
                            });
                          },
                          initialValue: init,
                          maxValue: 20,
                          minValue: 0)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
