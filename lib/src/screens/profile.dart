import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/themeColors.dart';
import 'login.dart';
import 'track.dart';
import 'home.dart';
import 'address.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Add new address',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddressScreen()));
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                primary: ThemeColors.teals,
              ),
            ),
            SizedBox(height: 30.0,),
            ElevatedButton(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              onPressed: () {
                auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                primary: ThemeColors.teals,
              ),
            ),
          ],
        ),
      ),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (icon == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TrackScreen()));
          } else {}
        },
      ),
    );
  }
}
