import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/widgets/customBottomNavBar.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../src/utilities/enums.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  FirestoreUsers _firestoreService = FirestoreUsers();
  String _displayName = "", _email = "";

  StreamSubscription<User> loginStateSubscription;

  // @override
  // void initState() {
  //   var authBloc = Provider.of<AuthBloc>(context, listen: false);
  //   loginStateSubscription = authBloc.currentUser.listen((fbUser) {
  //     if (fbUser == null) {
  //       Navigator.of(context).pushNamed('/login');
  //
  //     }
  //   });
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   loginStateSubscription.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    if (authBloc.user != null) {
      _displayName = authBloc.user.displayName;
      _email = authBloc.user.email;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(height: 40),
          Text(
            'Profile',
            style: TextStyles.heading1(),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              initialValue: _displayName,
              decoration: InputDecoration(
                  hoverColor: ThemeColors.teals,
                  fillColor: ThemeColors.light,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Name"),
              onChanged: (value) {
                _displayName = value.trim();
              },
              textInputAction: TextInputAction.newline,
              onFieldSubmitted: (term) {
                authBloc.user.updateDisplayName(
                  _displayName,
                );
                _firestoreService.updateName(_displayName);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              initialValue: _email,
              decoration: InputDecoration(
                hoverColor: ThemeColors.teals,
                fillColor: ThemeColors.light,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: "Email",
              ),
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // ignore: deprecated_member_use
            child: FlatButton(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: ThemeColors.light,
                onPressed: () {
                  Navigator.pushNamed(context, '/pickAddress');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 30,
                      color: ThemeColors.teals,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      "Add New Address",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: ThemeColors.teals),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // ignore: deprecated_member_use
            child: FlatButton(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: ThemeColors.light,
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email');
                  authBloc.logout();
                  loginStateSubscription =
                      authBloc.currentUser.listen((fbUser) {
                    if (fbUser == null) {
                      Navigator.of(context).pushNamed('/login');
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      size: 30,
                      color: ThemeColors.teals,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: ThemeColors.teals),
                  ],
                )),
          )
        ]),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
