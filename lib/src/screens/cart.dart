import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:collection/collection.dart';
import 'package:numberpicker/numberpicker.dart';

class CartScreen extends StatefulWidget {
  final List cartItems;

  const CartScreen(this.cartItems);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartList;
  List quantity;
  int joinTimer = 20;

  @override
  Widget build(BuildContext context) {
    cartList = groupBy(widget.cartItems, (e) => e.foodId)
        .values
        .map((e) => e[0])
        .toList();

    quantity = groupBy(widget.cartItems, (e) => e.foodId)
        .values
        .map((e) => e.length)
        .toList();

    return Scaffold(
      appBar: Header.getAppBar(title: 'View Cart'),
      backgroundColor: Colors.white,
      body: cartList.isEmpty
          ? Center(child: Text('Add items to cart'))
          : Stack(
              children: [
                Scrollbar(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 330),
                      child: ListView.builder(
                          itemCount: cartList.length,
                          itemBuilder: (context, index) {
                            return _cartItem(
                                cartList[index].foodName,
                                '\$' + cartList[index].price.toString(),
                                cartList[index].image,
                                index);
                          })),
                ),
                createOrder(),
              ],
            ),
    );
  }

  Widget createOrder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 300.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Divider(thickness: 1),
              setJoinDuration(),
              paymentSummary(),
              AppButton(
                buttonText: 'CREATE ORDER',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CheckoutScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget setJoinDuration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Wait  ', style: TextStyles.heading3()),
        NumberPicker(
          minValue: 5,
          maxValue: 60,
          step: 5,
          value: joinTimer,
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
              joinTimer = value;
            });
          },
        ),
        Text('  minutes for others to join', style: TextStyles.heading3()),
      ],
    );
  }

  Widget paymentSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subtotal', style: TextStyles.body()),
            Text('Delivery Fee', style: TextStyles.body()),
            SizedBox(height: 10.0),
            Text('Your Total', style: TextStyles.heading3()),
          ],
        ),
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$12.00', style: TextStyles.body()),
            Text('\$2.00 - \$10.00', style: TextStyles.body()),
            SizedBox(height: 10.0),
            Text('\$14.00 - \$25.00', style: TextStyles.heading2()),
          ],
        ),
      ],
    );
  }

  Widget _cartItem(String name, String price, String image, int index) {
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
                setState(() {
                  quantity[index] = value;
                });
              },
              initialValue: quantity[index],
              maxValue: 20,
              minValue: 0)
        ],
      ),
    );
  }
}
