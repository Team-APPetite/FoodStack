import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
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
  bool isPooler = false;
  bool enableCheckout = false;

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
      enableCheckout = true;
    }
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

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 75.0,
            ),
            enableCheckout
                ? Container()
                : Column(
                  children: [
                    Text(
                        'Wait while others join the order',
                        style: TextStyles.heading2(),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),

            Table(
              children: [
                TableRow(children: [
                  Center(
                    child: Text(
                      '${orderProvider.cartIds.length}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 40.0,
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
            SizedBox(
              height: 75.0,
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
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.oranges,
                      ),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Center(
                    child: (_minutesRemaining() == 1)
                        ? Text(
                            '${_minutesRemaining()} minutes remaining',
                            style: TextStyles.heading3(),
                          )
                        : Text(
                            '${_minutesRemaining()} minutes remaining',
                            style: TextStyles.heading3(),
                          ),
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 50.0,
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
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
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
              ),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckoutScreen()));
                            }),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16.0,
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
