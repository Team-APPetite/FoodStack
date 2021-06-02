import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/customBottomNavBar.dart';
import 'package:foodstack/src/themeColors.dart';
import '../../enums.dart';
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FlatButton(
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Color(0XFFF56f9),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => AddressScreen()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.map_outlined, color: ThemeColors.teals,),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text("Add New Address",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,
                          )
                      ),
                      Icon(Icons.arrow_forward, color: ThemeColors.teals),
                    ],
                  )
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
      bottomNavigationBar: customBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}


