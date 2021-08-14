import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/alerts.dart';
import 'package:foodstack/src/utilities/time.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/foodCard.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  DateTime _orderCompletionTime;
  bool isPooler = false;

  String restaurantId;
  String restaurantName;
  double deliveryFee;
  String restaurantLogo;

  @override
  void initState() {
    super.initState();
    _setOrderCompletionTime();
  }

  Future<bool> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    isPooler = prefs.getBool('isPooler');
    return isPooler;
  }

  Future<void> _setOrderCompletionTime() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    isPooler = await _getUserRole();

    if (isPooler) {
      await orderProvider.getNearbyOrder(restaurantId);
      setState(() {
        _orderCompletionTime = orderProvider.orderTime;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (showDialog(context: context, builder: Alerts.loseCart()) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) {
      restaurantId = arguments['restaurantId'];
      restaurantName = arguments['restaurantName'];
      deliveryFee = arguments['deliveryFee'];
      restaurantLogo = arguments['image'];
    }

    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    menuProvider.selectRestaurant = restaurantId;
    cartProvider.deliveryFee = deliveryFee;
    cartProvider.restaurantId = restaurantId;
    cartProvider.restaurantName = restaurantName;

    Widget viewCart() {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.light,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  (!isPooler || _orderCompletionTime != null)
                      ? AppButton(
                          keyString: 'viewCartButton',
                          buttonText: 'VIEW CART',
                          onPressed: () {
                            Navigator.pushNamed(context, '/cart');
                          },
                        )
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text('Getting nearby order details...'),
                        )),
                  Material(
                    child: InkResponse(
                      child: cartProvider.itemQuantityIcon(),
                      onTap: () {
                        (!isPooler || _orderCompletionTime != null)
                            ? Navigator.pushNamed(context, '/cart')
                            : print('');
                      },
                    ),
                    shape: CircleBorder(),
                  )
                ],
              ),
            ),
          ));
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: CustomScrollView(slivers: [
              Header.getSliverAppBar(
                  title: restaurantName,
                  details: isPooler && _orderCompletionTime != null
                      ? Text(
                          'Order by ${TimeHelper.formatTime(_orderCompletionTime)}',
                          style: TextStyles.textButton(),
                        )
                      : null,
                  logo: restaurantLogo,
                  alert: cartProvider.itemCount > 0 ? 'loseCart' : 'none',
                  height: MediaQuery.of(context).size.height / 3),
              SliverToBoxAdapter(
                child: isPooler && _orderCompletionTime != null
                    ? Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              'Order by ${TimeHelper.formatTime(_orderCompletionTime)}',
                              style: TextStyles.textButton(),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              StreamBuilder<List<FoodItem>>(
                  stream: menuProvider.menu,
                  builder: (context, snapshot) {
                    return (snapshot.data == null)
                        ? SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()))
                        : SliverPadding(
                            padding: EdgeInsets.all(8.0),
                            sliver: SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return FoodCard(
                                      index,
                                      snapshot.data[index].foodId,
                                      snapshot.data[index].foodName,
                                      snapshot.data[index].description,
                                      snapshot.data[index].price,
                                      snapshot.data[index].image,
                                      restaurantId);
                                }, childCount: snapshot.data.length)),
                          );
                  }),
            ]),
          ),
          viewCart(),
        ],
      )),
    );
  }
}
