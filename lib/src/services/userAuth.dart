import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodstack/src/models/user.dart';
import 'package:foodstack/src/services/firestoreUsers.dart';


class UserAuth {
  final FirebaseAuth auth;
  final FirestoreUsers firestoreService = FirestoreUsers();

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

  Future<String>  signup(String _firstName, String _lastName, String _email, String _password,
      String _passwordConfirmation) async {
    try {
      if (_firstName == '' && _lastName == '' && _email == '' && _password == '' && _passwordConfirmation == ''){
        return "Please fill in your details";
      }else if (_firstName == '') {
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
        UserCredential result = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        User user = result.user;
        String _displayName = _firstName + " " + _lastName;
        user.updateDisplayName(_displayName);
        var currUser = Users(uid: result.user.uid, email: result.user.email, name: _displayName);
        await firestoreService.addUser(currUser);
        return "Success";
      }
    } on FirebaseAuthException catch (error) {
          return error.message;
    }
  }
}
