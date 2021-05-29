import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'home.dart';
import 'profile.dart';
import 'package:foodstack/src/themeColors.dart';

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Coming Soon')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined, size: 25),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined, size: 25),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 25),
            label: 'Profile',
          ),
        ],
        selectedItemColor: ThemeColors.teals,
        currentIndex: 1,
        onTap: (icon) {
          if (icon == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (icon == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          } else {}
        },
      ),
    );
  }
}
