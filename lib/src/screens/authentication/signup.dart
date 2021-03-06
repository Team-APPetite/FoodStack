import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstack/src/blocs/auth_blocs.dart';
import 'package:foodstack/src/models/user.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';
import 'package:foodstack/src/services/userAuth.dart';
import 'package:foodstack/src/styles/textStyles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/styles/themeColors.dart';
import 'package:foodstack/src/widgets/button.dart';
import 'package:foodstack/src/widgets/header.dart';
import 'package:foodstack/src/widgets/socialButton.dart';
import 'package:foodstack/src/widgets/textField.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _header(),
                    _signupForm(),
                    _socialLogin(),
                  ]),
            ),
          ),
        ));
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          'Get Started',
          style: TextStyles.heading1(),
        ),
        SizedBox(height: 30.0)
      ],
    );
  }

  Widget _signupForm() {
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
            onPressed: () async {
              String state = await UserAuth(auth: auth).signup(_firstName,
                  _lastName, _email, _password, _passwordConfirmation);

              if (state == "Success") {
                User user = auth.currentUser;
                String _displayName = _firstName + " " + _lastName;
                user.updateDisplayName(_displayName);
                var currUser =
                    Users(uid: user.uid, email: user.email, name: _displayName);
                await firestoreService.addUser(currUser).then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('email', user.email);
                });
                Navigator.pushNamed(context, '/verifyEmail');
              } else {
                Fluttertoast.showToast(
                  msg: '$state',
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 5,
                  backgroundColor: ThemeColors.dark,
                );
              }
            }),
        SizedBox(height: 50.0),
      ],
    );
  }

  Widget _socialLogin() {
    final authBloc = Provider.of<AuthBloc>(context);

    return Column(
      children: [
        Text(
          'or Sign up with',
          style: TextStyles.body(),
        ),
        SizedBox(height: 15.0),
        SocialButton(
          keyString: 'googleLogin',
          image: Image.asset('images/google.png'),
          onPressed: () async {
            await authBloc.loginGoogle().then((value) async {
              if (value == "Success") {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('email', _email);
                Navigator.pushNamed(context, '/home');
              } else if (value == "New User") {
                User user = auth.currentUser;
                var currUser = Users(uid: user.uid, email: user.email);
                await firestoreService.addUser(currUser);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('email', user.email);
                Navigator.pushNamed(context, '/welcome');
              } else {
                Fluttertoast.showToast(
                  msg: 'Sign up with Google failed. Please try again later',
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 5,
                  backgroundColor: ThemeColors.dark,
                );
              }
            });
          },
        ),
        SizedBox(height: 50.0)
      ],
    );
  }
}
