import 'package:flutter/material.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.getAppBar(),
        body: Center(
            child: AppButton(
          buttonText: 'CONFIRM',
          onPressed: () {

          },
        )));
  }
}
