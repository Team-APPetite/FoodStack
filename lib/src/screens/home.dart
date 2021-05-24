import 'package:flutter/material.dart';
import 'package:foodstack/src/themeColors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(children: [
        Text(
          'Welcome to FoodStack',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: ThemeColors.dark,
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
                child: Text(
                  'Start a new order',
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
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
                child: Text(
                  'Join nearby orders',
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
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
                child: Text(
                  'Favourites',
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
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
                child: Text(
                  'Place your recent orders',
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
          ],
        )
        ),
    );
  }
}
