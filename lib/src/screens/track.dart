import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/customBottomNavBar.dart';
import 'package:foodstack/enums.dart';

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Coming Soon')),
      bottomNavigationBar: customBottomNavBar (selectedMenu: MenuState.track)
    );
  }
}
