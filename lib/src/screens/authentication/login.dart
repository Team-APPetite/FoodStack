import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/screens/home.dart';
import 'package:foodstack/src/services/userAuth.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/textField.dart';
import 'package:foodstack/src/widgets/socialButton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '', _password = '';
  final auth = FirebaseAuth.instance;
  //final peristence = FirebaseAuth.instance.setPersistence(Persistence.SESSION);

  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    Widget _header() {
      return Text(
        'FoodStack',
        style: TextStyles.title(),
      );
    }

    Widget _loginForm() {
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
        SizedBox(height: 15.0),
        TextButton(
          child: Text(
            'Forgot Password?',
            style: TextStyles.link(),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/resetPassword');
          },
        ),
        SizedBox(height: 15.0),
        AppButton(
          buttonText: 'LOGIN',
          onPressed: () async {
            String state = await UserAuth(auth: auth).login(_email, _password);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', _email);
            if (state == "Success") {
              Navigator.pushNamed(context, '/home');
            } else {
              Fluttertoast.showToast(
                msg: '$state',
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 5,
                backgroundColor: ThemeColors.dark,
              );
            }
          },
        ),
        SizedBox(height: 30.0),
      ]);
    }

    Widget _socialLogin() {
      return Column(
        children: [
          // Text(
          //   'or Sign in with',
          //   style: TextStyles.body(),
          // ),
          // SizedBox(height: 15.0),
          SignInButton(
            Buttons.Google,
            onPressed: () => authBloc.loginGoogle(),
          )
        ],
      );
    }

    Widget _newUser() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New to FoodStack?',
            style: TextStyles.body(),
          ),
          TextButton(
            child: Text(
              'Sign Up',
              style: TextStyles.textButton(),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                _loginForm(),
                _socialLogin(),
                _newUser(),
              ]),
        ),
      ),
    );
  }
}
