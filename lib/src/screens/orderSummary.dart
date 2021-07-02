import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/paymentProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/screens/track.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/utilities/numbers.dart';
import 'package:foodstack/src/utilities/statusEnums.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    super.initState();
    _setOrderStatus();
    orderProvider.setStatusAsPaid();
  }

  _setOrderStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('orderStatus', Status.none.toString());
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);

    final double _subtotal = cartProvider.getSubtotal();
    final double _deliveryFee = restaurantProvider.deliveryFee;
    final int _numOfUsers = orderProvider.cartIds.length;
    final double _finalDeliveryFee = _deliveryFee / _numOfUsers;
    final double _total = _subtotal + _finalDeliveryFee;

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

    Widget _paymentSummary(String title, String input) {
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
                  Text(title, style: TextStyles.heading3()),
                ],
              ),
            ),
            Text(input, style: TextStyles.heading3()),
          ],
        ),
      );
    }

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: Header.getAppBar(title: 'Order Summary', back: false),
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your order has been confirmed!',
                style: TextStyles.heading2(),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30.0,
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
              _paymentSummary('Subtotal', '\$$_subtotal'),
              _paymentSummary('Number of people in the order', '$_numOfUsers'),
              _paymentSummary('Delivery Fee',
                  '\$$_deliveryFee \/ $_numOfUsers = \$${Numbers.roundTo2d(_finalDeliveryFee)}'),
              _paymentSummary('Total', '\$${Numbers.roundTo2d(_total)}'),
              SizedBox(
                height: 75.0,
              ),
              _paymentSummary('Payment method', paymentProvider.paymentMethod),
              _paymentSummary('Amount paid', '\$${Numbers.roundTo2d(_total)}'),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton(
                      buttonText: 'TRACK ORDER',
                      onPressed: () {
                        cartProvider.clearCart();
                        orderProvider.clearOrder();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackScreen()));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
