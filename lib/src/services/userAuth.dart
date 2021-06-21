import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodstack/src/styles/themeColors.dart';

class UserAuth {
  final FirebaseAuth auth;

  UserAuth({this.auth});

  Future<String> login(String _email, String _password) async {
    try {
      if (_email == '' && _password == '') {
        return "Please fill in your details";
      } else if (_email == '') {
        return "Please enter your email address";
      } else {
        await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        return "Success";
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }
}