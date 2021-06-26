import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/timerProvider.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitScreen extends StatefulWidget {
  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  DateTime _orderCompletionTime;
  bool isPooler = true; // Change to false after testing

  @override
  void initState() {
    super.initState();
    _checkIfOrderComplete();
  }

  Future<void> _setOrderCompletionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    await prefs.setInt(
        'orderCompletionTime', orderProvider.orderTime.millisecondsSinceEpoch);
    setState(() => _orderCompletionTime = orderProvider.orderTime);
  }

  Future<void> _checkIfOrderComplete() async {
    DateTime currentTime = DateTime.now();

    await _setOrderCompletionTime();

    if (currentTime.compareTo(_orderCompletionTime) > 0) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => CheckoutScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    Widget _cartItem(String id, String name, String price, String image) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(flex: 1, child: Image.network(image)),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(name, style: TextStyles.heading3()),
                  SizedBox(height: 10.0),
                  Text(price, style: TextStyles.emphasis()),
                ],
              ),
            ),
            Text('${cartProvider.getItemQuantityOf(id)}',
                style: TextStyles.heading3()),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: Header.getAppBar(),
        body: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Wait while others join the order',
                  style: TextStyles.heading2(),
                ),
                Table(
                  children: [
                    TableRow(children: [
                      Center(
                        child: Text(
                          '${orderProvider.cartIds.length}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.oranges,
                          ),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Center(
                        child: (orderProvider.cartIds.length == 1)
                            ? Text(
                                'Person has joined the order',
                                style: TextStyles.heading3(),
                              )
                            : Text(
                                'People have joined the order',
                                style: TextStyles.heading3(),
                              ),
                      ),
                    ]),
                  ],
                ),
                Table(
                  children: [
                    TableRow(children: [
                      Center(
                        child: Text(
                          'Order completes at',
                          style: TextStyles.heading3(),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Center(
                        child: Text(
                          '${_orderCompletionTime.hour}:${_orderCompletionTime.minute}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.oranges,
                          ),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Center(
                        child: Text(
                          '${timerProvider.timer} minutes remaining',
                          style: TextStyles.heading3(),
                        ),
                      ),
                    ]),
                  ],
                ),
                Text(
                  'Your Cart',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.oranges,
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      return _cartItem(
                        cartProvider.cartItems[index].foodId,
                        cartProvider.cartItems[index].foodName,
                        '\$' + cartProvider.cartItems[index].price.toString(),
                        cartProvider.cartItems[index].image,
                      );
                    }),

                // Checkout button added only for testing payments
                AppButton(
                    buttonText: 'CHECKOUT',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckoutScreen()));
                    })
              ],
            )));
  }
}
