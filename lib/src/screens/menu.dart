import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/menuProvider.dart';
import 'package:foodstack/src/models/foodItem.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/screens/cart.dart';
import 'package:foodstack/src/screens/details.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/foodCard.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final double deliveryFee;

  MenuScreen({this.restaurantId, this.restaurantName, this.deliveryFee});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  DateTime _orderCompletionTime = DateTime.now();
  bool isPooler = false;

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
      await orderProvider.getOrder(widget.restaurantId);
      setState(() {
        _orderCompletionTime = orderProvider.orderTime;
      });
    }
  }

  // TODO Add search bar
  // TODO Add restaurant image by putting GridView in column(expanded())
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    menuProvider.selectRestaurant = widget.restaurantId;
    cartProvider.deliveryFee = widget.deliveryFee;
    cartProvider.restaurantId = widget.restaurantId;

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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
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
          title: widget.restaurantName,
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
                                    itemBuilder: (context, index) =>
                                        ChangeNotifierProvider.value(
                                            value: cartProvider,
                                            child: FoodCard(
                                                snapshot.data[index].foodId,
                                                snapshot.data[index].foodName,
                                                snapshot.data[index].price,
                                                snapshot.data[index].image, () {
                                              menuProvider.loadFoodItem(
                                                  widget.restaurantId,
                                                  snapshot.data[index]);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                              menuProvider)));
                                            })),
                                  ),
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
