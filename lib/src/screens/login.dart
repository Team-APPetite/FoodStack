import 'package:flutter/material.dart';
import 'package:foodstack/src/screens/signup.dart';
import 'package:foodstack/src/themeColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: [
          SizedBox(height: 75.0),
          Text(
            'FoodStack',
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 60.0,
              fontWeight: FontWeight.bold,
              color: ThemeColors.dark,
            ),
          ),
          SizedBox(height: 45.0),
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
          SizedBox(height: 45.0),
          TextButton(
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(height: 45.0),
          ElevatedButton(
            onPressed: () {
              auth
                  .signInWithEmailAndPassword(
                      email: _email, password: _password)
                  .then((_) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              });
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
              child: Text(
                'LOGIN',
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
          SizedBox(height: 50.0),
          Text(
            'or Sign in with',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 30.0),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              height: 60,
              width: 60,
              child: ElevatedButton(
                child: Image.asset('images/google.png'),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), primary: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(height: 45.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New to FoodStack?',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              TextButton(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
