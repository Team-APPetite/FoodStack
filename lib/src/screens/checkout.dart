import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/userLocator.dart';
import 'package:foodstack/src/screens/address.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/screens/wait.dart';
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
  FirestoreUsers firestoreService = FirestoreUsers();
  int value = 0;

  DateTime _orderCompletionTime;
  bool isPooler = false;

  @override
  void initState() {
    super.initState();
    _getUserRole();
    _checkIfOrderComplete();
  }

  Future<bool> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    isPooler = prefs.getBool('isPooler');
    return isPooler;
  }

  Future<void> _setOrderCompletionTime() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      setState(() => _orderCompletionTime = orderProvider.orderTime);
  }

  Future<void> _checkIfOrderComplete() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    DateTime currentTime = DateTime.now();

    await _setOrderCompletionTime();

    if (currentTime.compareTo(_orderCompletionTime) < 0) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => WaitScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userLocator = Provider.of<UserLocator>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    LatLng userCoordinates = userLocator.coordinates;
    GoogleMapController _mapController;

    void whenMapCreated(GoogleMapController _controller) {
      setState(() {
        _mapController = _controller;
      });
    }

    return Scaffold(
        appBar: Header.getAppBar(
        title:
        'Checkout'), // Can set back: false later to avoid going back after confirming cart
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
                            isPooler
                                ? Container()
                                : OutlinedButton(
                                    child: Text('Change Address',
                                        style: TextStyles.textButton()),
                                    style: OutlinedButton.styleFrom(
                                        primary: ThemeColors.oranges,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        side: BorderSide(
                                          color: ThemeColors.oranges,
                                          width: 1,
                                        )),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddressScreen()));
                                    },
                                  ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          isPooler ? 'Pay creator' : 'Payment Methods',
                          style: TextStyles.heading2(),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: paymentLabels.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Radio(
                                visualDensity: VisualDensity.compact,
                                activeColor: ThemeColors.oranges,
                                value: index,
                                groupValue: value,
                                onChanged: (i) => setState(() => value = i),
                              ),
                              title: Text(
                                paymentLabels[index],
                                style: TextStyle(color: ThemeColors.dark),
                              ),
                              trailing: Icon(paymentIcons[index],
                                  color: ThemeColors.oranges),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppButton(
                              buttonText: 'PAY',
                              onPressed: () {
                                orderProvider.clearOrder();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            ),
                          ],
                        ),
                      ))
                    ])));
  }
}
