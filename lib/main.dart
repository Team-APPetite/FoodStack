import 'package:flutter/material.dart';
import 'package:foodstack/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodstack/src/screens/authentication/login.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/screens/track.dart';
import 'package:foodstack/src/screens/wait.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email');
  String orderStatus = prefs.getString('orderStatus');
  print(orderStatus);
  await Firebase.initializeApp();
  runApp(App(
      home: email != null
          ? (orderStatus == 'Status.none' || orderStatus == 'Status.delivered')
              ? HomeScreen()
              : (orderStatus == 'Status.active' ||
                      orderStatus == 'Status.full' ||
                      orderStatus == 'Status.closed')
                  ? WaitScreen()
                  : TrackScreen()
          : LoginScreen()));
}
