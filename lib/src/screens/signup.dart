import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/models/user.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'verify.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _passwordConfirmation = '';
  final auth = FirebaseAuth.instance;
  final FirestoreUsers firestoreService = FirestoreUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.getAppBar(),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            header(),
            signupForm(),
          ]),
        ));
  }

  Widget header() {
    return Column(
      children: [
        Text(
          'Sign Up',
          style: TextStyles.heading1(),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }

  Widget signupForm() {
    return Column(
      children: [
        AppTextField(
          hintText: 'FIRST NAME',
          onChanged: (value) {
            _firstName = value.trim();
          },
        ),
        SizedBox(height: 15.0),
        AppTextField(
          hintText: 'LAST NAME',
          onChanged: (value) {
            _lastName = value.trim();
          },
        ),
        SizedBox(height: 15.0),
        AppTextField(
            hintText: 'EMAIL',
            textInputType: TextInputType.emailAddress,
            onChanged: (value) {
              _email = value.trim();
            }),
        SizedBox(height: 15.0),
        AppTextField(
          hintText: 'PASSWORD',
          obscureText: true,
          onChanged: (value) {
            _password = value.trim();
          },
        ),
        SizedBox(height: 15.0),
        AppTextField(
          hintText: 'CONFIRM PASSWORD',
          obscureText: true,
          onChanged: (value) {
            _passwordConfirmation = value.trim();
          },
        ),
        SizedBox(height: 50.0),
        AppButton(
          buttonText: 'SIGN UP',
          onPressed: () => _signup(
              _firstName, _lastName, _email, _password, _passwordConfirmation),
        ),
        SizedBox(height: 100.0)
      ],
    );
  }

  _signup(String _firstName, String _lastName, String _email, String _password,
      String _passwordConfirmation) async {
    try {
      if (_firstName == '') {
        Fluttertoast.showToast(
          msg: 'Please enter your first name',
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
        );
      } else if (_lastName == '') {
        Fluttertoast.showToast(
          msg: 'Please enter your last name',
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
        );
      } else if (_email == '') {
        Fluttertoast.showToast(
          msg: 'Please enter your email address',
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
        );
      } else if (_password == '') {
        Fluttertoast.showToast(
          msg: 'Please enter a password',
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
        );
      } else if (_password != _passwordConfirmation) {
        Fluttertoast.showToast(
          msg: 'Passwords do not match',
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
        );
      } else {
        UserCredential result = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        User user = result.user;
        String _diplayName = _firstName + " " + _lastName;
        user.updateProfile(displayName: _diplayName);
        var currUser = Users(uid: result.user.uid, email: result.user.email, name: _diplayName);
        await firestoreService.addUser(currUser);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VerifyScreen()));
      }
    } on FirebaseAuthException catch (error) {
      print(error);
      Fluttertoast.showToast(
        msg: '${error.message}',
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
      );
    }
  }
}
