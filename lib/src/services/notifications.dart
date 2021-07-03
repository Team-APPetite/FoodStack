import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


// Initialize the plugin
  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher-playstore');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Scheduled notification
  Future scheduledNotification(int joinDuration) async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone)); 

  await _flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Pay for your order',
    'You can checkout now for the meal you have ordered!',
    tz.TZDateTime.now(tz.local).add(Duration(minutes: joinDuration)),
    const NotificationDetails(
        android: AndroidNotificationDetails('0',
            'FoodStack', 'Order Closing Notification')),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }
}
