import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    Widget setJoinDuration() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Wait  ', style: TextStyles.heading3()),
          NumberPicker(
            minValue: 5,
            maxValue: 60,
            step: 5,
            value: cartProvider.joinDuration,
            haptics: true,
            axis: Axis.vertical,
            itemHeight: 30.0,
            itemWidth: 50.0,
            selectedTextStyle: TextStyles.textButton(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: ThemeColors.oranges),
            ),
            onChanged: (value) {
              setState(() {
                cartProvider.joinDuration = value;
              });
            },
          ),
          Text('  minutes for others to join', style: TextStyles.heading3()),
        ],
      );
    }

    Widget paymentSummary() {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Table(
          children: [
            TableRow( children: [
              Text('Subtotal', style: TextStyles.body()),
              Text(cartProvider.getSubtotal().toString(), style: TextStyles.body()),
            ]),
            TableRow( children: [
              Text('Delivery Fee', style: TextStyles.body()),
              Text(cartProvider.deliveryFeeRange(), style: TextStyles.body()),
            ]),
            TableRow( children: [
              SizedBox(height: 10),
              SizedBox(height: 10),
            ]),
            TableRow( children: [
              Text('Your Total', style: TextStyles.heading3()),
              Text(cartProvider.totalRange(), style: TextStyles.heading2()),
            ]),
          ],
      ),
        );
    }

    Widget createOrder() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 300.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ThemeColors.light,
                blurRadius: 4,
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                setJoinDuration(),
                paymentSummary(),
                AppButton(
                  buttonText: 'CHECKOUT',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: cartProvider,
                            child: CheckoutScreen(),
                          ),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      );
    }

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
            CustomNumberPicker(
                onValue: (value) {
                  if (value == 0) {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(pageBuilder: (_, __, ___) => super.widget));
                  }
                  cartProvider.updateItemQuantityOf(id, value);

                },
                initialValue: cartProvider.getItemQuantityOf(id),
                maxValue: 20,
                minValue: 0)
          ],
        ),
      );
    }

    return Scaffold(
      appBar: Header.getAppBar(title: 'View Cart'),
      backgroundColor: Colors.white,
      body: cartProvider.cartItems.isEmpty
          ? Center(child: Text('Add items to cart'))
          : Stack(
              children: [
                Scrollbar(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 300),
                      child: ListView.builder(
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
                          })),
                ),
                createOrder(),
              ],
            ),
    );
  }
}
