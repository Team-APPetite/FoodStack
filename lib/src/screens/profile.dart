import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/widgets/back.dart';
import 'package:foodstack/src/themeColors.dart';
import 'track.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [Center(child: Text('Coming Soon')), BackArrow()]),
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
        currentIndex: 2,
        onTap: (icon) {
          if (icon == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (icon == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TrackScreen()));
          } else {

          }
        },
      ),

    );
  }
}
