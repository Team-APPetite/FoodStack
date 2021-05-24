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
            SizedBox(height: 100.0),
            Text(
              'Welcome to FoodStack',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: ThemeColors.dark,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300.0),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 200),
                  child: ElevatedButton.icon(
                  onPressed: () {},

                   icon: Icon(Icons.add_shopping_cart),

                   label: Text(
                      'Start a New Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),

                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                     ),
                    primary: ThemeColors.oranges,
                  ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 200),
                  child: ElevatedButton.icon(
                  onPressed: () {},
                    icon: Icon(Icons.person_add_alt_1_outlined),
                    label: Text(
                      'Join Nearby Orders',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: ThemeColors.oranges,
                  ),
                ),
                ),
             ]
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300.0),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 200),
                  child: ElevatedButton.icon(
                      onPressed: () {},
                        icon: Icon(Icons.favorite_border_outlined),
                        label: Text(
                          'Favourites',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),

                      style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      ),
                        primary: ThemeColors.oranges,
                      ),
                  ),
                ),

                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 200),
                  child:ElevatedButton.icon(
                    onPressed: () {},
                      icon: Icon(Icons.access_time),
                      label: Text(
                        'Recent Orders',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                         fontSize: 16.0,
                      ),
                    ),

                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: ThemeColors.oranges,
                  ),
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