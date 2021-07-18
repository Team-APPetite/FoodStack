import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  final FirebaseAuth auth;
  UserAuth({this.auth});

  Future<String> signInWithCredential(AuthCredential credential) async {
    try {
      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (authResult.additionalUserInfo.isNewUser && user != null) {
        return "New User";
      } else {
        return "Success";
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future<void> logout() => auth.signOut();

  Stream<User> get currentUser => auth.authStateChanges();
  User get user => auth.currentUser;

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

  Future<String> signup(String _firstName, String _lastName, String _email,
      String _password, String _passwordConfirmation) async {
    try {
      if (_firstName == '' &&
          _lastName == '' &&
          _email == '' &&
          _password == '' &&
          _passwordConfirmation == '') {
        return "Please fill in your details";
      } else if (_firstName == '') {
        return 'Please enter your first name';
      } else if (_lastName == '') {
        return 'Please enter your last name';
      } else if (_email == '') {
        return 'Please enter your email address';
      } else if (_password == '') {
        return 'Please enter a password';
      } else if (_password != _passwordConfirmation) {
        return 'Passwords do not match';
      } else {
        await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        return "Success";
      }
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }
}
