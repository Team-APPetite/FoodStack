import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: Header.getAppBar(),
        body: Center(
            child: Column(
          children: [
            AppButton(
              buttonText: 'CONFIRM',
              onPressed: () {
                cartProvider.confirmCart();
                orderProvider.setOrder();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ],
        )));
  }
}
