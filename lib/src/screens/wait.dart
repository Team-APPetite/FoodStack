import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/alerts.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitScreen extends StatefulWidget {
  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  DateTime _orderCompletionTime = DateTime.now();
  bool isPooler = false;
  bool enableCheckout = false;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _getUserRole();
    _checkIfOrderComplete();
    _getOrderInfo();
  }

  Future<bool> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    isPooler = prefs.getBool('isPooler');
    return isPooler;
  }

  Future<void> _setOrderCompletionTime() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    setState(() => _orderCompletionTime = orderProvider.orderTime);

    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      orderProvider.getOrder(orderProvider.orderId);
    });
  }

  Future<void> _checkIfOrderComplete() async {
    DateTime currentTime = DateTime.now();

    await _setOrderCompletionTime();
    if (currentTime.compareTo(_orderCompletionTime) > 0) {
      timer.cancel();
      setState(() {
        enableCheckout = true;
      });
    } else {
      setState(() {
        enableCheckout = false;
      });
    }
  }

  Future<void> _getOrderInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String orderId = prefs.getString('orderId');
    String cartId = prefs.getString('cartId');
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    await orderProvider.getOrder(orderId);
    cartProvider.getCart(cartId);
    restaurantProvider.getRestaurant(orderProvider.restaurantId);
  }

  int _minutesRemaining() {
    DateTime currentTime = DateTime.now();
    int minutes;
    if (_orderCompletionTime.hour > currentTime.hour) {
      minutes = 60 - (currentTime.minute - _orderCompletionTime.minute);
    } else {
      minutes = _orderCompletionTime.minute - currentTime.minute;
    }
    return minutes;
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    _checkIfOrderComplete();

    Widget _cartItem(String id, String name, String price, String image) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(name, style: TextStyles.heading3()),
                  SizedBox(height: 5.0),
                  Text(price, style: TextStyles.emphasis()),
                ],
              ),
            ),
            Text('x ${cartProvider.getItemQuantityOf(id)}',
                style: TextStyles.heading3()),
          ],
        ),
      );
    }

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              enableCheckout
                  ? Container()
                  : Column(
                      children: [
                        Text(
                          'Wait while others join the order',
                          style: TextStyles.heading2(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
              Column(
                children: [
                  Text(
                    '${orderProvider.cartIds.length}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.oranges,
                    ),
                  ),
                  (orderProvider.cartIds.length == 1)
                      ? Text(
                          'Person has joined the order',
                          style: TextStyles.heading3(),
                        )
                      : Text(
                          'People have joined the order',
                          style: TextStyles.heading3(),
                        ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Order completes at',
                    style: TextStyles.heading3(),
                  ),
                  Text(
                    '${_orderCompletionTime.hour}:${_orderCompletionTime.minute}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.oranges,
                    ),
                  ),
                  enableCheckout
                      ? Container()
                      : (_minutesRemaining() == 1)
                          ? Text(
                              '${_minutesRemaining()} minute remaining',
                              style: TextStyles.heading3(),
                            )
                          : Text(
                              '${_minutesRemaining()} minutes remaining',
                              style: TextStyles.heading3(),
                            ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Your Cart',
                    style: TextStyles.heading2(),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: ThemeColors.light,
                        width: 1,
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Scrollbar(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartProvider.cartItems.length,
                            itemBuilder: (context, index) {
                              return _cartItem(
                                cartProvider.cartItems[index].foodId,
                                cartProvider.cartItems[index].foodName,
                                '\$' +
                                    cartProvider.cartItems[index].price
                                        .toString(),
                                cartProvider.cartItems[index].image,
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text('Subtotal', style: TextStyles.heading3())),
                    Text('\$${cartProvider.getSubtotal()}',
                        style: TextStyles.emphasis()),
                  ],
                ),
              ),
              enableCheckout
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton(
                              buttonText: 'CHECKOUT',
                              onPressed: () {
                                Navigator.pushNamed(context, '/checkout');
                              }),
                        ],
                      ),
                    )
                  : TextButton(
                      child: Text(
                        'Cancel Order',
                        style: TextStyles.textButton(),
                      ),
                      onPressed: () {
                        showDialog<String>(
                            context: context, builder: Alerts.cancelOrder());
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
