import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/utilities/statusEnums.dart';
import 'package:foodstack/src/utilities/time.dart';
import 'package:foodstack/src/widgets/customBottomNavBar.dart';
import 'package:foodstack/src/utilities/enums.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  static const int noOfMillisecondsPerSecond = 1000;

  DateTime orderCompletionTime;
  DateTime currentTime;
  DateTime orderPickupTime;
  DateTime orderDeliveryTime;
  DateTime clearOrderTrackTime;

  bool isPooler = false;
  bool isCartAvailable = false;
  String orderStatus = Status.none.toString();
  String orderId;
  Timer timer;

  String header;
  Image image;
  String details;

  @override
  void initState() {
    _checkOrderStatus();
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      // 2 minutes
      _checkOrderStatus();
    });
    super.initState();
  }

  Future<void> _setOrderCompletionTime() async {
    final prefs = await SharedPreferences.getInstance();
    orderId = prefs.getString('orderId');
    setState(() {
      orderCompletionTime = DateTime.fromMillisecondsSinceEpoch(
          prefs.getInt('orderCompletionTime') * noOfMillisecondsPerSecond);
      currentTime = DateTime.now();
      orderPickupTime =
          orderCompletionTime.add(Duration(seconds: 60)); // 10 minutes
      orderDeliveryTime =
          orderPickupTime.add(Duration(seconds: 30)); // 20 minutes
      clearOrderTrackTime =
          orderDeliveryTime.add(Duration(seconds: 30)); // 10 minutes
    });
  }

  Future<void> _checkOrderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String prefsStatus = prefs.getString('orderStatus');
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    await _setOrderCompletionTime();
    if (currentTime.compareTo(clearOrderTrackTime) > 0) {
      setState(() {
        orderStatus = Status.none.toString();
        if (prefsStatus == Status.paid.toString() ||
            prefsStatus == Status.prepared.toString()) {
          orderProvider.setStatusAsDelivered(orderId);
        }
      });
    } else if (currentTime.compareTo(orderDeliveryTime) > 0) {
      setState(() {
        orderStatus = Status.delivered.toString();
        orderProvider.setStatusAsDelivered(orderId);
      });
    } else if (currentTime.compareTo(orderPickupTime) > 0) {
      setState(() {
        orderStatus = Status.prepared.toString();
      });
    } else if (currentTime.compareTo(orderCompletionTime) > 0) {
      setState(() {
        orderStatus = Status.paid.toString();
      });
    } else {
      setState(() {
        orderStatus = Status.none.toString();
      });
    }
  }

  _preparing() {
    header = 'Your order is being prepared';
    image = Image.asset('images/Track_Page_Preparing_UI.gif');
    _estimateDeliveryTime();
  }

  _delivering() {
    header = 'Your order is being delivered';
    image = Image.asset('images/Track_Page_Delivering_UI.gif');
    _estimateDeliveryTime();
  }

  _delivered() {
    header = 'Enjoy your meal!';
    image = Image.asset('images/Track_Page_Delivered_UI.gif');
    details = '';
  }

  _noStatus() {
    header = '';
    image = Image.asset('images/FoodStack_Logo_LightGrey.gif', height: 150);
    details = '\nPlace an order to track its status here!\n';
  }

  _estimateDeliveryTime() {
    details =
        'Estimated delivery time: ${orderDeliveryTime.hour}:${orderDeliveryTime.minute}';
    if (TimeHelper.minutesRemaining(orderDeliveryTime, DateTime.now()) > 1)
      details = details +
          '\n\nWithin ${TimeHelper.minutesRemaining(orderDeliveryTime, DateTime.now())} minutes';
    else if (TimeHelper.minutesRemaining(orderDeliveryTime, DateTime.now()) ==
        1)
      details = details +
          '\n\nWithin ${TimeHelper.minutesRemaining(orderDeliveryTime, DateTime.now())} minute';
    else
      details = details + '\n\nYour order will be arriving soon';
  }

  @override
  Widget build(BuildContext context) {
    if (orderStatus == 'Status.paid')
      _preparing();
    else if (orderStatus == 'Status.prepared')
      _delivering();
    else if (orderStatus == 'Status.delivered')
      _delivered();
    else
      _noStatus();
    return Scaffold(
        backgroundColor:
            orderStatus == 'Status.none' ? Colors.white : Colors.grey[50],
        appBar: Header.getAppBar(title: 'Track Your Order', back: false),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              header != ''
                  ? Text(
                      header,
                      style: TextStyles.heading2(),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              image,
              details != ''
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: ThemeColors.light,
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(details,
                            style: TextStyles.heading3(),
                            textAlign: TextAlign.center),
                      ),
                    )
                  : Container(),
              SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.track));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
