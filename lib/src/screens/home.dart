import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/utilities/alerts.dart';
import 'package:foodstack/src/utilities/statusEnums.dart';
import 'package:foodstack/src/widgets/bigButton.dart';
import 'package:foodstack/src/widgets/customBottomNavBar.dart';
import 'package:foodstack/src/utilities/enums.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer _timer;
  bool isOnline = true;

  @override
  void initState() {
    _getOrderStatus();
    final firestoreService = FirestoreUsers();
    final authBloc = Provider.of<AuthBloc>(context, listen: false);

    firestoreService.saveDeviceToken();
    firestoreService.setUserProperties();
    final userLocator = Provider.of<UserLocator>(context, listen: false);
    userLocator.getCameraLocation();
    _getConnectivityStatus();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!isOnline || !userLocator.isOnline) {
        showDialog<String>(context: context, builder: Alerts.noInternet());
        timer.cancel();
      }
      if (userLocator.deliveryAddress != null) {
        _showDeliveryAddress();
        firestoreService.updateAddress(
            authBloc.user.uid, userLocator.deliveryAddress.addressLine);
        firestoreService.updateCoordinates(
            authBloc.user.uid, userLocator.getUserLocation());
        timer.cancel();
      }
    });
    super.initState();
  }

  Future<void> _getConnectivityStatus() async {
    isOnline = await InternetConnectionChecker().hasConnection;
  }

  _getOrderStatus() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);

    final prefs = await SharedPreferences.getInstance();
    String orderStatus = prefs.getString('orderStatus');
    if (orderStatus == Status.delivered.toString()) {
      String orderId = prefs.getString('orderId');
      await orderProvider.getOrder(orderId);
      String restaurantId = orderProvider.restaurantId;
      await restaurantProvider.getRestaurant(restaurantId);
      showDialog<String>(context: context, builder: Alerts.provideRating());
    }
  }

  _showDeliveryAddress() {
    final userLocator = Provider.of<UserLocator>(context, listen: false);

    Fluttertoast.showToast(
      msg: 'Delivering at ${userLocator.deliveryAddress.addressLine}',
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: ThemeColors.dark,
    );
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
                        Navigator.pushNamed(context, '/newOrder');
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
                        Navigator.pushNamed(context, '/joinOrders');
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
                          Navigator.pushNamed(context, '/favourites');
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
                          Navigator.pushNamed(context, '/recentOrders');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.order));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
