import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/widgets/customBottomNavBar.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import '../enums.dart';
import 'login.dart';
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
                  //color: Color(0XFFF56f9),
                  color: ThemeColors.light,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => AddressScreen()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.map_outlined, size: 30, color: ThemeColors.teals,),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text("Add New Address",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,
                          )
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: ThemeColors.teals),
                    ],
                  )
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FlatButton(
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  // color: Color(0XFFF56f9),
                  color: ThemeColors.light,
                  onPressed: () {
                    auth.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.logout_outlined, size: 30, color: ThemeColors.teals,),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text("Logout",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,
                          )
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: ThemeColors.teals),
                    ],
                  )
              ),
            ),
          ]
        ),
      ),
    bottomNavigationBar: customBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}


