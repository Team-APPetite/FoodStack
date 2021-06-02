import 'package:flutter/material.dart';
import 'package:foodstack/src/screens/signup.dart';
import 'package:foodstack/src/screens/reset.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/textField.dart';
import 'package:foodstack/src/widgets/socialButton.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 120.0, horizontal: 30.0),
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
      SizedBox(height: 20.0),
      TextButton(
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ResetScreen()));
        },
      ),
      SizedBox(height: 20.0),
      AppButton(
        buttonText: 'LOGIN',
        onPressed: () => _login(_email, _password),
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
        SocialButton(image: Image.asset('images/google.png')),
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
                fontWeight: FontWeight.bold),
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
