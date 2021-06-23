import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaitScreen extends StatefulWidget {
  @override
  _WaitScreenState createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {

  DateTime _orderCompletionTime;
  bool isPooler = false;

  @override
  void initState() {
    super.initState();
    _checkIfOrderComplete();
  }

  Future<void> _setOrderCompletionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    await prefs.setInt('orderCompletionTime', orderProvider.orderTime.millisecondsSinceEpoch);
    setState(() => _orderCompletionTime = orderProvider.orderTime);
  }

  Future<void> _checkIfOrderComplete() async {
    DateTime currentTime = DateTime.now();

    await _setOrderCompletionTime();

    if (currentTime.compareTo(_orderCompletionTime) > 0) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => CheckoutScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(), // remove later to avoid reordering
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Order will be completed at: '),
            ],
          ),
      ),

    );
  }
}
