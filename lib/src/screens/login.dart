import 'package:flutter/material.dart';
import 'package:foodstack/src/screens/signup.dart';
import 'package:foodstack/src/screens/reset.dart';
import 'package:foodstack/src/themeColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '', _password = '';
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          header(),
          loginForm(),
          socialLogin(),
          newUser(),
        ]),
      ),
    );
  }

  Widget header() {
    return Text(
      'FoodStack',
      style: TextStyle(
        fontFamily: 'Avenir',
        fontSize: 60.0,
        fontWeight: FontWeight.bold,
        color: ThemeColors.dark,
      ),
    );
  }

  Widget loginForm() {
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
      SizedBox(height: 20.0),
      TextButton(
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
            //decoration: TextDecoration.underline,
            //fontWeight: FontWeight.bold
          ),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ResetScreen()));
        },
      ),
      SizedBox(height: 20.0),
      ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
          child: Text(
            'LOGIN',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        onPressed: () => _login(_email, _password),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: ThemeColors.oranges,
        ),
      ),
      SizedBox(height: 20.0),
    ]);
  }

  Widget socialLogin() {
    return Column(
      children: [
        Text(
          'or Sign in with',
          style: TextStyle(
            color: ThemeColors.dark,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 20.0),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            height: 60,
            width: 60,
            child: ElevatedButton(
              child: Image.asset('images/google.png'),
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), primary: Colors.white),
              onPressed: () {
                // TODO Google Sign In
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget newUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to FoodStack?',
          style: TextStyle(
            color: ThemeColors.dark,
            fontSize: 16.0,
          ),
        ),
        TextButton(
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: ThemeColors.oranges,
              fontSize: 16.0,
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
        ),
      ],
    );
  }

  _login(String _email, String _password) async {
    try {
      if (_email == '') {
        Fluttertoast.showToast(
          msg: 'Please enter your email address',
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
        );
      } else {
        await auth.signInWithEmailAndPassword(
            email: _email, password: _password);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
        msg: '${error.message}',
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
      );
    }
  }
}
