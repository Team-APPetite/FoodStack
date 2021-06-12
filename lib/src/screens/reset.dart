import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/textField.dart';

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
          style: TextStyles.heading1(),
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
          style: TextStyles.body(),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.0)
      ],
    );
  }

  Widget resetForm() {
    return Column(children: [
      AppTextField(
        hintText: 'EMAIL',
        textInputType: TextInputType.emailAddress,
        onChanged: (value) {
          _email = value.trim();
        },
      ),
      SizedBox(height: 50.0),
      AppButton(buttonText: 'SEND EMAIL', onPressed: () => _reset(_email),),
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
