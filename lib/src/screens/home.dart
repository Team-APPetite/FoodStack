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
          padding: EdgeInsets.all(30.0),
          child: Column(children: [
            SizedBox(height: 100.0),
            Text(
              'Welcome to FoodStack',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: ThemeColors.dark,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                  onPressed: () {},
                   child: Padding(
                     padding: const EdgeInsets.all(20.0),
                     child: Column(
                       children: [
                         Text(
                            'New Order',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                         Icon(Icons.add_shopping_cart, size: 75,),
                       ],
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
                SizedBox(width: 10, height: 300.0),
                Expanded (
                  child: ElevatedButton(
                  onPressed: () {},
                    // Icon(Icons.person_add_alt_1_outlined),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            'Nearby Orders',
                             textAlign: TextAlign.center,
                             style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Icon(Icons.person_add_alt_1_outlined, size: 60,),
                        ],
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
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(23.0),
                          child: Column(
                            children: [
                              Text(
                                'Favourites',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              Icon(Icons.favorite_border_outlined,size: 75),
                            ],
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
                SizedBox(width: 10, height: 150.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'Recent Orders',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                               fontSize: 18.0,
                            ),
                    ),
                            Icon(Icons.access_time_outlined, size: 65),
                          ],
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined, size: 25),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined, size: 25),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 25),
            label: 'Profile',
          ),
        ],
        selectedItemColor: ThemeColors.oranges,

      ),
    );
  }
}