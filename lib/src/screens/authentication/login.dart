import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/models/user.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
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
  final FirestoreUsers firestoreService = FirestoreUsers();

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
            keyString: 'loginEmail',
            hintText: 'EMAIL',
            textInputType: TextInputType.emailAddress,
            onChanged: (value) {
              _email = value.trim();
            }),
        SizedBox(height: 15.0),
        AppTextField(
          keyString: 'loginPassword',
          hintText: 'PASSWORD',
          obscureText: true,
          onChanged: (value) {
            _password = value.trim();
          },
        ),
        SizedBox(height: 15.0),
        TextButton(
          key: Key('resetPasswordButton'),
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
          keyString: 'loginButton',
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
      ]);
    }

    Widget _socialLogin() {
      return Column(
        children: [
          Text(
            'or Sign in with',
            style: TextStyles.body(),
          ),
          SizedBox(height: 15.0),
          SocialButton(
            keyString: 'googleLogin',
            image: Image.asset('images/google.png'),
            onPressed: () async {
              String msg = await authBloc.loginGoogle();
              if (msg == "Success") {
                Navigator.pushNamed(context, '/home');
              } else if (msg == "New User") {
                User user = auth.currentUser;
                var currUser = Users(uid: user.uid, email: user.email);
                await firestoreService.addUser(currUser).then((value) async {});
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('email', user.email);

                Navigator.pushNamed(context, '/welcome');
              } else {
                Fluttertoast.showToast(
                  msg: '$msg',
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 5,
                  backgroundColor: ThemeColors.dark,
                );
              }
            },
          ),
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
            key: Key('signUpButton'),
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
