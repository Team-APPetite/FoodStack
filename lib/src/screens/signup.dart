import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/themeColors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'verify.dart';

import 'home.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(children: [
        SizedBox(height: 75.0),
        Text(
          'Sign Up for FoodStack',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: ThemeColors.dark,
          ),
        ),
        SizedBox(height: 70.0),
        TextField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'FIRST NAME',
            hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ThemeColors.teals,
                width: 2.0,
              ),
            ),
          ),
          onChanged: (value) {
            _firstName = value.trim();
          },
        ),
        SizedBox(height: 15.0),
        TextField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'LAST NAME',
            hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ThemeColors.teals,
                width: 2.0,
              ),
            ),
          ),
          onChanged: (value) {
            _lastName = value.trim();
          },
        ),
        SizedBox(height: 15.0),
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
        SizedBox(height: 15.0),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'PASSWORD',
            hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ThemeColors.teals,
                width: 2.0,
              ),
            ),
          ),
          onChanged: (value) {
            _password = value.trim();
          },
        ),
        SizedBox(height: 15.0),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'CONFIRM PASSWORD',
            hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ThemeColors.teals,
                width: 2.0,
              ),
            ),
          ),
          onChanged: (value) {
            _passwordConfirmation = value.trim();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 110.0),
            ElevatedButton(
              onPressed: () => _signup(_firstName, _lastName, _email, _password,
                  _passwordConfirmation),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 80.0, vertical: 16.0),
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                primary: ThemeColors.oranges,
              ),
            ),
          ],
        ),
      ]),
    ));
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
        await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerifyScreen()));
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
