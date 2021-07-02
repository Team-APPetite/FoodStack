import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'dart:async';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(back: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email,
              size: 100,
              color: ThemeColors.teals,
            ),
            Text(
              'Verify your email',
              style: TextStyles.heading1(),
            ),
            SizedBox(height: 30.0),
            Text(
              'A verification email has been sent to ${user.email}, please verify.',
              style: TextStyles.body(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100.0)
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushNamed(
          context, '/welcome');
    }
  }
}
