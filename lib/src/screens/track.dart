import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/utilities/statusEnums.dart';
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
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    await _setOrderCompletionTime();
    if (currentTime.compareTo(clearOrderTrackTime) > 0) {
      setState(() {
        orderStatus = Status.none.toString();
      });
    } else if (currentTime.compareTo(orderDeliveryTime) > 0) {
      setState(() {
        orderStatus = Status.delivered.toString();
        orderProvider.setStatusAsDelivered(orderId);
      });
    } else if (currentTime.compareTo(orderPickupTime) > 0) {
      setState(() {
        orderStatus = Status.pickedUp.toString();
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

  Widget _preparingUI() {
    return Column(
      children: [
        Center(child: Text('paid')),
      ],
    );
  }

  Widget _deliveringUI() {
    return Column(
      children: [
        Center(child: Text('pickedUp')),
      ],
    );
  }

  Widget _deliveredUI() {
    return Column(
      children: [
        Center(child: Text('delivered')),
      ],
    );
  }

  Widget _noStatus() {
    return Column(
      children: [
        Center(child: Text('none')),
      ],
    );
  }

  // Progress line with 4 circles: 
  // order confirmed, 
  // order being prepared, 
  // order being delivered, 
  // order delivered.

  // Clip art for each case

  // Estimated delivery time
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.getAppBar(title: 'Track Your Order', back: false),
        body: orderStatus == 'Status.paid'
            ? _preparingUI()
            : orderStatus == 'Status.pickedUp'
                ? _deliveringUI()
                : orderStatus == 'Status.delivered'
                    ? _deliveredUI()
                    : _noStatus(),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.track));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
