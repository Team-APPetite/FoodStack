import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/themeColors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/widgets/header.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email = '';
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.getAppBar(),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          header(),
          instructions(),
          resetForm(),
        ]),
      ),
    );
  }

  Widget header() {
    return Column(
      children: [
        Text(
          'Reset Password',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: ThemeColors.dark,
          ),
        ),
        SizedBox(height: 30.0)
      ],
    );
  }

  Widget instructions() {
    return Column(
      children: [
        Text(
          'Enter your email to receive instructions for resetting your password',
          style: TextStyle(
            color: ThemeColors.dark,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.0)
      ],
    );
  }

  Widget resetForm() {
    return Column(children: [
      TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'EMAIL',
          hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ThemeColors.teals,
              width: 2.0,
            ),
          ),
        ),
        onChanged: (value) {
          _email = value.trim();
        },
      ),
      SizedBox(height: 50.0),
      ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
          child: Text(
            'SEND EMAIL',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        onPressed: () => _reset(_email),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: ThemeColors.oranges,
        ),
      ),
      SizedBox(height: 50.0)
    ]);
  }

  _reset(String _email) async {
    try {
      // User user = auth.currentUser;
      // if (user.emailVerified) {
        await auth.sendPasswordResetEmail(email: _email);
        Navigator.of(context).pop();
      // } else {
      //   Fluttertoast.showToast(
      //     msg: 'This email is not verified',
      //     gravity: ToastGravity.TOP,
      //     timeInSecForIosWeb: 5,
      //   );
      // }
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
        msg: '${error.message}',
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
      );
    }
  }
}
