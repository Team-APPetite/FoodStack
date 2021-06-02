import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/widgets/bigButton.dart';
import 'package:foodstack/src/widgets/customBottomNavBar.dart';
import 'package:foodstack/src/enums.dart';
import 'package:foodstack/src/styles/themeColors.dart';

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Hungry? Order Now',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.dark,
                  ),
                ),
                // TODO Search for restaurants
                CupertinoSearchTextField(
                  padding: EdgeInsets.all(15.0),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: BigButton(
                      buttonText: 'Start a\nNew Order',
                      icon: Icons.add_shopping_cart,
                      color: ThemeColors.mint,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: BigButton(
                      buttonText: 'Nearby\nOrders',
                      icon: Icons.person_add_alt_1_outlined,
                      color: ThemeColors.oranges,
                      onPressed: () {},
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BigButton(
                        buttonText: 'Your\nFavourites',
                        icon: Icons.favorite_border_outlined,
                        color: ThemeColors.yellows,
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: BigButton(
                        buttonText: 'Recent\nOrders',
                        icon: Icons.access_time_outlined,
                        color: ThemeColors.teals,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            )),
        bottomNavigationBar: customBottomNavBar(selectedMenu: MenuState.order));
  }
}
