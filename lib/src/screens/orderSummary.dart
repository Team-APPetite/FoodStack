import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/restaurantProvider.dart';
import 'package:foodstack/src/providers/timerProvider.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {



  @override
  Widget build(BuildContext context) {
    final restaurantProvider =  Provider.of<RestaurantProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);


    Widget _cartItem(String id, String name, String price, String image) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            //Expanded(flex: 1, child: Image.network(image)),
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

    Widget _paymentSummary() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Table(
          children: [
            TableRow(children: [
              Text('Subtotal', style: TextStyles.body()),
              Text('${cartProvider.getSubtotal()}',
                  style: TextStyles.body()),
            ]),
            TableRow(children: [
              Text('Number of people that joined the order', style: TextStyles.body()),
              Text('${orderProvider.cartIds.length}', style: TextStyles.body()),
            ]),
            TableRow(children: [
              Text('Delivery Fee', style: TextStyles.body()),
              Text('${restaurantProvider.deliveryFee}', style: TextStyles.body()),
            ]),
            TableRow(children: [
              Text('Total', style: TextStyles.heading3()),
              Text(cartProvider.totalRange(), style: TextStyles.heading2()),
            ]),
          ],
        ),
      );
    }


    return Scaffold(
      appBar: Header.getAppBar(title: 'Order Summary'),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 75.0,
            ),
            Text(
              'Your order has been confirmed',
              style: TextStyles.heading2(),
            ),

            SizedBox(
              height: 50.0,
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
                        '\$' +
                            cartProvider.cartItems[index].price
                                .toString(),
                        cartProvider.cartItems[index].image,
                      );
                    }),
              ),
            ),

            _paymentSummary(),

          ],
        ),
      ),

    );
  }
}
