import 'package:flutter/material.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
              'Welcome to\nFoodStack!',
              style: TextStyles.heading1(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            Text(
              'FoodStack is your one-stop solution for placing group orders without any hassle.',
              style: TextStyles.body(),
              textAlign: TextAlign.center,
            ),
            Expanded(child: Image.asset('images/Welcome_Screen.gif')),
            Text(
              'Get started by setting your delivery address to view nearby orders.',
              style: TextStyles.body(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            AppButton(
                buttonText: 'LET\'S GO!',
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                  Navigator.pushNamed(context, '/pickAddress');
                }),
            SizedBox(height: 100.0)
          ],
        ),
      ),
    );
  }
}
