import 'package:flutter/material.dart';
import 'package:foodstack/src/providers/orderProvider.dart';
import 'package:foodstack/src/providers/timerProvider.dart';
import 'package:foodstack/src/screens/checkout.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
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
    final timerProvider = Provider.of<TimerProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Wait while others join the order',
                style: TextStyles.heading2(),
              ),

               // Text('${orderProvider.cartIds.length}',
               //   style: TextStyles.heading1(),
               // ),

              Text(
                'People have joined your order',
                style: TextStyles.body(),
              ),

              Table(
                children: [
                  TableRow(children: [
                    Center(
                      child: Text(
                        'Order completes at',
                        style: TextStyles.heading3(),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Center(
                      child: Text(
                        '${_orderCompletionTime.hour}:${_orderCompletionTime.minute}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.oranges,
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Center(
                      child: Text('${timerProvider.joinDuration} minutes remaining',
                        style: TextStyles.heading3(),
                      ),
                    ),

                  ]),
                ],
              ),



              Text('Your Cart',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.oranges,
                ),
              )




            ],
          ),
      ),

    );
  }
}
