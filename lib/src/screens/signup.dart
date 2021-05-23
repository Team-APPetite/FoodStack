import 'package:flutter/material.dart';
import 'package:foodstack/src/app.dart';
import 'package:foodstack/src/themeColors.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(children: [
        SizedBox(height: 75.0),
        Text(
          'Sign Up for FoodStack',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: ThemeColors.dark,
          ),
        ),
        SizedBox(height: 70.0),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'EMAIL',
            hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ThemeColors.teals,
                width: 2.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'PASSWORD',
            hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ThemeColors.teals,
                width: 2.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'CONFIRM PASSWORD',
            hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ThemeColors.teals,
                width: 2.0,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 110.0),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 80.0, vertical: 16.0),
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                primary: ThemeColors.oranges,
              ),
            ),
          ],
        ),
      ]),
    ));
  }
}
