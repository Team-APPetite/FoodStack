import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
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
  DateTime _orderCompletionTime = DateTime.now();
  bool isPooler = false;

  String restaurantId;
  String restaurantName;
  double deliveryFee;

  @override
  void initState() {
    super.initState();
    _setOrderCompletionTime();
  }

  Future<bool> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final isPooler = prefs.getBool('isPooler');
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

  // TODO Add restaurant image by putting GridView in column(expanded())
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) {
      restaurantId = arguments['restaurantId'];
      restaurantName = arguments['restaurantName'];
      deliveryFee = arguments['deliveryFee'];
    }

    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    menuProvider.selectRestaurant = restaurantId;
    cartProvider.deliveryFee = deliveryFee;
    cartProvider.restaurantId = restaurantId;

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
                  AppButton(
                    buttonText: 'VIEW CART',
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  cartProvider.itemQuantityIcon(),
                ],
              ),
            ),
          ));
    }

    return Scaffold(
        appBar: Header.getAppBar(
          title: restaurantName,
          alert: cartProvider.itemCount > 0 ? 'loseCart' : 'none',
        ),
        body: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 100.0),
              child: StreamBuilder<List<FoodItem>>(
                  stream: menuProvider.menu,
                  builder: (context, snapshot) {
                    return (snapshot.data == null)
                        ? Center(child: CircularProgressIndicator())
                        : Scrollbar(
                            child: Column(
                              children: [
                                isPooler
                                    ? Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                            'Order by ${_orderCompletionTime.hour}:${_orderCompletionTime.minute}',
                                            style: TextStyles.textButton(),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return FoodCard(
                                            snapshot.data[index].foodId,
                                            snapshot.data[index].foodName,
                                            snapshot.data[index].price,
                                            snapshot.data[index].image);
                                      }),
                                ),
                              ],
                            ),
                          );
                  }),
            ),
            viewCart(),
          ],
        ));
  }
}
