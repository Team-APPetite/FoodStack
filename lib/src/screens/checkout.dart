import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/paymentProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/services/braintreeService.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/payment.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int value = 0;
  bool isPooler = false;

  FirestoreUsers firestoreService = FirestoreUsers();

  @override
  void initState() {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    super.initState();
    orderProvider.getOrder(orderProvider.orderId);
    orderProvider.closeOrder();
    _getUserRole();
  }

  Future<bool> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    isPooler = prefs.getBool('isPooler');
    return isPooler;
  }

  @override
  Widget build(BuildContext context) {
    final userLocator = Provider.of<UserLocator>(context);
    LatLng userCoordinates = userLocator.coordinates;
    GoogleMapController _mapController;

    final orderProvider = Provider.of<OrderProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);

    final double _subtotal = cartProvider.getSubtotal();
    final double _deliveryFee = cartProvider.deliveryFee;
    final int _numOfUsers = orderProvider.cartIds.length;
    final double _finalDeliveryFee = _deliveryFee / _numOfUsers;
    final double _total = _subtotal + _finalDeliveryFee;

    void whenMapCreated(GoogleMapController _controller) {
      setState(() {
        _mapController = _controller;
      });
    }

    return Scaffold(
        appBar: Header.getAppBar(title: 'Checkout'),
        body: (userLocator.deliveryAddress == null)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Deliver to',
                          style: TextStyles.heading2(),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Expanded(
                        child: Stack(
                          children: [
                            GoogleMap(
                              mapType: MapType.normal,
                              cameraTargetBounds: CameraTargetBounds(
                                  LatLngBounds(
                                      southwest: userCoordinates,
                                      northeast: userCoordinates)),
                              initialCameraPosition: CameraPosition(
                                target: userCoordinates,
                                zoom: 15,
                              ),
                              onMapCreated: whenMapCreated,
                            ),
                            Center(
                              child: Container(
                                child: Icon(
                                  Icons.location_pin,
                                  color: ThemeColors.oranges,
                                  size: 50.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userLocator.deliveryAddress.addressLine,
                              style: TextStyles.body(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            'Payment Methods',
                            style: TextStyles.heading2(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: paymentLabels.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              activeColor: ThemeColors.oranges,
                              value: index,
                              groupValue: value,
                              onChanged: (i) => setState(() => value = i),
                              title: Text(
                                paymentLabels[index],
                                style: TextStyle(color: ThemeColors.dark),
                              ),
                              secondary: Icon(paymentIcons[index],
                                  color: ThemeColors.oranges),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: AppButton(
                            buttonText: 'PAY',
                            onPressed: () async {
                              if (value == 0) {
                                String result =
                                    await BraintreeService.makePayment(
                                        _total, 'FoodStack');
                                if (result == "Payment successful!") {
                                  orderProvider.setStatusAsPaid(
                                      orderProvider.orderId);
                                  paymentProvider.addPayment(
                                      orderProvider.orderId,
                                      _total,
                                      paymentLabels[value]);
                                  Navigator.pushNamed(
                                      context, '/orderSummary');
                                } else {
                                  Fluttertoast.showToast(
                                    msg: result,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: ThemeColors.dark,
                                  );
                                }
                              } else {
                                orderProvider
                                    .setStatusAsPaid(orderProvider.orderId);
                                paymentProvider.addPayment(
                                    orderProvider.orderId,
                                    _total,
                                    paymentLabels[value]);
                                Navigator.pushNamed(
                                    context, '/orderSummary');
                              }
                            }),
                      )
                    ])));
  }
}
