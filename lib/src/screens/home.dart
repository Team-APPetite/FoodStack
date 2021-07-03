import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/widgets/bigButton.dart';
import 'package:foodstack/src/widgets/customBottomNavBar.dart';
import 'package:foodstack/src/utilities/enums.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    final userLocator = Provider.of<UserLocator>(context, listen: false );

    if (userLocator.deliveryAddress != null) {
      Fluttertoast.showToast(
        msg: 'Delivering at ${userLocator.deliveryAddress.addressLine}',
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: ThemeColors.dark,
      );
    }

    super.initState();
    _getUserOrderStatus();
  }

  Future<String> _getUserOrderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('status');
  }

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
                  style: TextStyles.heading1(),
                ),
                // TODO Search bar (Full-text / Restaurants only)
                CupertinoSearchTextField(
                  padding: EdgeInsets.all(15.0),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: BigButton(
                      buttonText: 'Start a\nNew Order',
                      icon: Icons.add_shopping_cart,
                      color: ThemeColors.mint,
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/newOrder');
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: BigButton(
                      buttonText: 'Join\nOrders',
                      icon: Icons.person_add_alt_1_outlined,
                      color: ThemeColors.oranges,
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/joinOrders');
                      },
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
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/favourites');
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: BigButton(
                        buttonText: 'Order\nAgain',
                        icon: Icons.access_time_outlined,
                        color: ThemeColors.teals,
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/recentOrders');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.order));
  }
}
