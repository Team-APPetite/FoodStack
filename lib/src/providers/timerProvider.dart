import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  Timer _timer;
  Duration _joinDuration;

  Duration get joinDuration => _joinDuration;
  Timer get timer => _timer;

  void startJoinTimer(int joinDuration) {
    _joinDuration = Duration(seconds: joinDuration); // change to minutes later
    _timer = Timer(_joinDuration, handleTimeout);
  }

  void handleTimeout() {
    // Process payment
    // Change order status to paid
    // Send order details to restaurant OMS
    // Notify creator and poolers
  }

  Widget minutesTimer() {

  }
}
