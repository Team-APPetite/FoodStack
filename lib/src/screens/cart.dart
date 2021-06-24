import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'package:foodstack/src/models/order.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/screens/track.dart';
import 'package:foodstack/src/screens/wait.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/statusEnums.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DateTime _orderCompletionTime;
  bool isPooler = false;

  @override
  void initState() {
    super.initState();
    _setOrderCompletionTime();
  }

  Future<bool> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPooler');
  }

  Future<void> _setOrderCompletionTime() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    isPooler = await _getUserRole();

    if (isPooler) {
      setState(() => _orderCompletionTime = orderProvider.orderTime);
    }
  }

  Future<void> _setUserOrderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('status', Status.active.toString());
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    final geo = Geoflutterfire();
    final userLocator = Provider.of<UserLocator>(context);
    GeoFirePoint userLocation = geo.point(
        latitude: userLocator.coordinates.latitude,
        longitude: userLocator.coordinates.longitude);

    Widget _setJoinDuration() {
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

    Widget _displayOrderCompletionTime() {
      return Container(
          child: Text(
        'Confirm cart by ${_orderCompletionTime.hour}:${_orderCompletionTime.minute}',
        style: TextStyles.textButton(),
      ));
    }

    Widget _paymentSummary() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Table(
          children: [
            TableRow(children: [
              Text('Subtotal', style: TextStyles.body()),
              Text(cartProvider.getSubtotal().toString(),
                  style: TextStyles.body()),
            ]),
            TableRow(children: [
              Text('Delivery Fee', style: TextStyles.body()),
              Text(cartProvider.deliveryFeeRange(), style: TextStyles.body()),
            ]),
            TableRow(children: [
              SizedBox(height: 10),
              SizedBox(height: 10),
            ]),
            TableRow(children: [
              Text('Your Total', style: TextStyles.heading3()),
              Text(cartProvider.totalRange(), style: TextStyles.heading2()),
            ]),
          ],
        ),
      );
    }

    Widget _createOrder() {
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
                isPooler ? _displayOrderCompletionTime() : _setJoinDuration(),
                _paymentSummary(),
                AppButton(
                  buttonText: 'CONFIRM CART',
                  onPressed: () {
                    cartProvider.confirmCart();
                    _setUserOrderStatus();
                    isPooler
                        ? orderProvider.addToCartsList(
                            cartProvider.cartId, orderProvider.orderId) // Need to update total price as well
                        : orderProvider.setOrder(
                            Order(
                                restaurantId: cartProvider.restaurantId,
                                coordinates: userLocation,
                                totalPrice: cartProvider.getSubtotal() +
                                    cartProvider.deliveryFee,
                                deliveryAddress:
                                    userLocator.deliveryAddress.addressLine),
                            cartProvider.joinDuration,
                            cartProvider.cartId);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckoutScreen()));
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
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => super.widget));
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
                _createOrder(),
              ],
            ),
    );
  }
}
