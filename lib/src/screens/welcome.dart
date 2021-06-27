import 'package:flutter/material.dart';
import 'package:foodstack/src/screens/address.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(back: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to FoodStack!',
              style: TextStyles.heading1(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            Text(
              'Set your delivery address to view available restaurants and join nearby orders.',
              style: TextStyles.body(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            AppButton(
                buttonText: 'PICK ADDRESS',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddressScreen()));
                }),
            SizedBox(height: 100.0)
          ],
        ),
      ),
    );
  }
}
