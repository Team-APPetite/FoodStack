import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/cartProvider.dart';
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
  DateTime _orderCompletionTime = DateTime.now();
  bool isPooler = false;
  bool isCartAvailable = false;
  String orderStatus = Status.none.toString();
  Timer timer;

  @override
  void initState() {
    super.initState();
    _getUserRole();
    _checkOrderStatus();
    _getOrderInfo();
  }

  Future<bool> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    isPooler = prefs.getBool('isPooler');
    return isPooler;
  }

  Future<void> _setOrderCompletionTime() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    setState(() => _orderCompletionTime = orderProvider.orderTime);

    timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      await orderProvider.getOrder(orderProvider.orderId);
    });
  }

  Future<void> _checkOrderStatus() async {
    DateTime currentTime = DateTime.now();

    _setOrderCompletionTime();
    if (currentTime.compareTo(_orderCompletionTime) > 0) {
      timer.cancel();
      setState(() {
        orderStatus = Status.closed.toString();
      });
    } else {
      setState(() {
      });
    }
  }

  Future<void> _getOrderInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String orderId = prefs.getString('orderId');
    String cartId = prefs.getString('cartId');
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await orderProvider.getOrder(orderId);
    await cartProvider.getCart(cartId);
    setState(() {
      isCartAvailable = true;
    });
  }

  int _minutesRemaining(DateTime time) {
    DateTime currentTime = DateTime.now();
    int minutes;
    if (time.hour > currentTime.hour) {
      minutes = 60 - (currentTime.minute - time.minute);
    } else {
      minutes = time.minute - currentTime.minute;
    }
    return minutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(title: 'Track Your Order', back: false),
        body: Column(),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.track));
  }
}
